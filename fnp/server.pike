#include "rv/FNP_Core.pike";     /* The Flightplaning Core*/
#include "rv/DataBase.pike";     /* include geo stuff */
#include "rv/Functions.pike";    /* include functions tools*/


mapping ini = read_setings("settings.ini");


int main(int argc, array(string) argv)

{

/* checking environment ..*/

	if(!Stdio.is_dir(ini->SESSIONDIR)) mkdir(ini->SESSIONDIR);


  if(argc == 2 && argv[1] =="--update") { write("UPDATING...\n"); return 0; }
  object server=Protocols.HTTP.Server.Port(handle_request, (int) ini->PORT);
  write("System running...\nopen your webbrowser and go to http://localhost:%s\n to stop the system, close this window.\n",(string) ini->PORT);
  return -1;
}

void  handle_request(Protocols.HTTP.Server.Request request)
{

  mapping query=([]);
  mapping ret =([]);
  string access ="NO";
  string file = request->not_query;
	int done;
  array file_ext = request->not_query/".";

  /*CHECK CONNECT PERMISSIONS*/

  array  tmp_ip = sprintf("%O",request->my_fd)/" ";
  string ip =  replace(tmp_ip[1],"\"","");
  array  ip_arr = ip/".";
  if(ini->ACCESS == "ALL") access ="YES";
  if(ini->ACCESS == "local" && ip == "127.0.0.1") access ="YES";
  if(ini->ACCESS == "local" && ip_arr[0] == "10" ) access ="YES";
  if(ini->ACCESS == "local" && ip_arr[0] == "172" && ip_arr[0] == "16" ) access ="YES";
  if(ini->ACCESS == "local" && ip_arr[0] == "192" && ip_arr[0] == "168" ) access ="YES";
  if( access =="NO")
	{
    	request->response_and_finish(([ "data": "Authentication failed.", "type" : "text/html" ]));
	}
  if( access =="YES")
	{
		if(request->query !="") { foreach(request->query/"&",string t) { array t1=t/"=";   query[t1[0]]=t1[1]; } } /* query mapping */

		switch(file) /* DYNMAIC FILES */
		{
		case "/"		: /* startpage (index.html :-) */
									ret = File_Server_Parsed(ini->STARTPAGE,request->query,"STARTPAGE",ini,"html");
									done =1;
									debug(sprintf("[%s %s] STARTPAGE %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
									break;

		case "/R/"	: /*Start New Route*/
									mapping FNP =Start_FNP(query,ini);
									ret = (["data" : FNP->data, "type" : "text/html" ]);
									done =1;
									debug(sprintf("[%s %s] START ROUTER %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
									break;

		}

		if(file[0..3] == "/FP_") /* Process Route */
		{
			mapping Start_FNP_Holding =Start_FNP_Holding(file,ini);
			ret = (["data" : Start_FNP_Holding->data, "type" : "text/html" ]);
			done =1;
				debug(sprintf("[%s %s] PROCESS ROUTE %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
		}
		if(file[0..4] == "/LOG_") /* Logfile Process */
		{
		string sess = replace(file,"/LOG_","");
		mapping show_log = show_log(sess);
		ret = (["data" :show_log->data, "type" : show_log->type ]);
		done =1;
		}

		if(file[0..6] == "/POPUP_") /* Logfile Process */
		{
		string sess = replace(file,"/POPUP_","");
		mapping popup = popup(sess,query);
		ret = (["data" :popup->data, "type" : popup->type ]);
		done =1;
		}

		if(file[0..5] == "/CALL_") /* Call Process */
		{
		string sess = replace(file,"/CALL_","");

		object t =Thread.thread_create( lambda() {FNP_Route(sess,ini); } );

		ret = (["data" : "0", "type" : "text/plain" ]);
		done =1;
		debug(sprintf("[%s %s] CALL %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
		}

		if(file[0..5] == "/PLAN_") /* PlanPages Process */
		{
		 file = replace(file,"/PLAN_","");
		if(file_ext[1] == "jpg") ret = (["data" : ServPlanFilePass(file,ini),  "type" : "image/jpeg" ]);
		if(file_ext[1] == "gif") ret = (["data" : ServPlanFilePass(file,ini),  "type" : "image/gif"  ]);
		if(file_ext[1] == "fnp") ret = (["data" : ServPlanFileParse(file,ini), "type" : "text/html"  ]);
		if(file_ext[1] == "map") ret = (["data" : ServPlanFilePass(file,ini), "type" : "image/jpeg"  ]);

		done =1;
		debug(sprintf("[%s %s] PLAN %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
		}

		if(file[0..6] == "/KLICK_") /* PlanPages Process */
		{
		 file = replace(file,"/KLICK_","");
		if(file_ext[1] == "fnp") ret = (["data" : FNP_KLick_Route(file,request->variables,ini), "type" : "text/html"  ]);
		if(file_ext[1] == "jpg") ret = (["data" : FNP_KLick_Route_Map(file,ini), "type" : "image/jpeg"  ]);
		done =1;
		debug(sprintf("[%s %s] KLICKER %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
		}



		if(done != 1)
		{
			switch(file_ext[sizeof(file_ext)-1]) /* SURF THE REST (STATIC FILES ) */
			{
			case "jpg"	:	ret = File_Server_Parsed(file,request->query,0,ini,"jpg"	); 	break;
			case "gif"	:	ret = File_Server_Parsed(file,request->query,0,ini,"gif"	);	break;
			case "html"	:	ret = File_Server_Parsed(file,request->query,0,ini,"html"	);	break;
  		case "css"	:	ret = File_Server_Parsed(file,request->query,0,ini,"css"	);	break;
  		case "js"		:	ret = File_Server_Parsed(file,request->query,0,ini,"js"		);	break;
			}
			debug(sprintf("[%s %s] FILESERVER %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query));
		}




		if(ret->data)  request->response_and_finish(([ "data": ret->data, "type":ret->type, "server": ret->server ]));
		if(!ret->data) request->response_and_finish(([ "data": "404?"+file+sprintf("\n%O",request->query), "type":"text/html" ]));

	} /* end access */
}








/* ...

// write("[%s %s] REQUEST %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query);

  if(file == "/RVSC_MAP/")  {ret = rvsc_map(query); type = "image/jpeg";}
  if(file == "/CODEFINDER/")
   {
	 if(request->query !="")
     {  ret =  get_codes(query->c); type = "text/html"; }
    else
     {ret = Stdio.FILE(ini->HTMLDIR+"/finder.tpl")->read(); type = "text/html";}
   }







*/
