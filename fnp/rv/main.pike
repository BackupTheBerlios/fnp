void  handle_request(Protocols.HTTP.Server.Request request)
{
  mapping ini = read_setings("settings.ini");
  mapping query=([]);
  string ret ="...";
  string access ="NO";
  
  string type = "text/html";
  string file = request->not_query;
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

  if( access =="NO")  {
  write("! BLOCKED ->");
  request->response_and_finish(([ "data": "Authentication failed.", "type":type ])); }
 
   if( access =="YES")  {
  
   

  

  if(request->query !="")
   {
    foreach(request->query/"&",string t)
    {
     array t1=t/"=";
     query[t1[0]]=t1[1];
    }
   }


  if(file == "/") {ret = Stdio.FILE(ini->HTMLDIR+"/"+ini->STARTPAGE)->read();  type = "text/html";

/* AC DATABASE */
  mapping Aircrafts = Load_AC_DataBase();
  
  string acs;
   foreach(indices(Aircrafts),string l )
   {
   acs += sprintf("<option value=\"%s\">%s (%s)</option>",(string)l,(string)l,(string)Aircrafts[l]->TYPE);
   }

     ret = replace(ret,"{AC-LIST}",acs);
  }
                      
  if(file_ext[sizeof(file_ext)-1] == "jpg") { ret = "BILD"; type = "text/html"; }
  if(file_ext[sizeof(file_ext)-1] == "html") {ret = "html"; type = "text/html"; }
  
  if(file == "/RVSC/route") { ret = rvsc(query); type = "text/html";  }

  if(file == "/RVSC_MAP/")  {ret = rvsc_map(query); type = "image/jpeg";}
  if(file == "/CODEFINDER/")
   {
    if(request->query !="")
     {  ret =  get_codes(query->c); type = "text/html"; }
    else
     {ret = Stdio.FILE(ini->HTMLDIR+"/finder.tpl")->read(); type = "text/html";}
   }

/* ok now serv the static files */   

  if(file_ext[sizeof(file_ext)-1] == "jpg") { ret = serv_file(file); type = "text/html"; }
  if(file_ext[sizeof(file_ext)-1] == "html") {ret = serv_file(file);  type = "text/html"; }
  if(file_ext[sizeof(file_ext)-1] == "css") {ret = serv_file(file);    type = "application/x-javascript"; }
  if(file_ext[sizeof(file_ext)-1] == "js") {ret = serv_file(file);    type = "application/x-javascript"; }


  


 string parsed_ret =  preparser(ret,request->query);  
 request->response_and_finish(([ "data": parsed_ret, "type":type ]));
 }
 write("[%s %s] REQUEST %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query);


}



string preparser(string x,string query)
{ mapping ini = read_setings("settings.ini");
 mapping vals =([]);
 vals["DEMO"] ="";
 vals["PRE_FROM"] ="";
   vals["PRE_TO"] ="";
   vals["VERSION"] = Stdio.FILE("version.txt")->read();

  if(ini->DEMO == "YES"){
   vals["DEMO"] =sprintf("The System running in DEMO mode, The Route is fixed imited from %s to %s",ini->DEMO_F,ini->DEMO_T);
   vals["PRE_FROM"] =ini->DEMO_F;
   vals["PRE_TO"] =ini->DEMO_T;
   }

    
if(query !="")
   {
    foreach(query/"&",string t)
    {
     array t1=t/"=";
     vals["QUERY{"+t1[0]+"}"]=t1[1];
    }
   }
     
   foreach(indices(vals),string l )
    {
     string t1=  "%"+l+"%";
     string t2=  vals[l];
     x = replace(x,t1,  t2);
    }    
return x;
}




                                                                              
 string rvsc(mapping query)
{
 mapping ini = read_setings("settings.ini");
 mapping DB = OpenDatabase("ficken");



 string from = upper_case(query->from);
 string to = upper_case(query->to);
 string ac = query->ac;



 string E="OK";
  if(from == to)                  return Send_Error("Departure and Destination the same");
  if(CheckInputICAO(from) != 1)   return Send_Error("\"" + from + "\": Invalid ICAO ID");
  if(CheckInputICAO(to) != 1)     return Send_Error("\"" + to   + "\": Invalid ICAO ID");
  if(GetICAOdata(from,DB)->error) return Send_Error("\"" + from + "\": Not in Database");
  if(GetICAOdata(to,DB)->error)   return Send_Error("\"" + to   + "\": Not in Database");
  

return router(from,to,ac,DB);

}



string  router(string from,string to,string ac, mapping DB)
  {
  mapping ini = read_setings("settings.ini");
  mapping AC = Load_AC_DataBase();

if(ini->DEMO == "YES") { from =ini->DEMO_F; to =ini->DEMO_T;}

  mapping output=([]);

   output["INI_NAME"] =(string)  ini->NAME;
   output["INI_WD"] = (string) ini->WD;
   output["INI_WS"] = (string) ini->WS;
   
   output["AC-TAS"] = (string)  AC[ac]->TAS;
   output["AC-REG"] = (string)  ac;
   output["AC-TYPE"] = (string)  AC[ac]->TYPE;
   output["AC-MOTW"] = (string)  AC[ac]->MOTW;
   output["AC-RANGE"] = (string)  AC[ac]->RANGE;
   output["AC-RMK"] = (string)  AC[ac]->RMK;
   

   output["ICAO1"] =from;
   output["ICAO2"] = to;
   output["NAME1"] = replace(replace(GetICAOdata(from,DB)->name,"\n",""),"\r","");
   output["NAME2"] = replace(replace(GetICAOdata(to,DB)->name,"\n",""),"\r","");
   output["RWY1"] =  replace(replace(GetICAOdata(from,DB)->runway,"\n",""),"\r","");
   output["RWY2"] =  replace(replace(GetICAOdata(to,DB)->runway,"\n",""),"\r","");
   float t_1 =  (float) GetICAOdata(from,DB)->lat;
   float t_2 =  (float) GetICAOdata(from,DB)->long;
   float t_3 =  (float) GetICAOdata(to,DB)->lat;
   float t_4 =  (float) GetICAOdata(to,DB)->long;
   output["LAT1"] = (string)t_1;
   output["LONG1"] =(string) t_2;
   output["LAT2"] = (string)t_3;
   output["LONG2"] = (string)t_4;
   object a=Geo(t_1,t_2);
   object b=Geo(t_3,t_4);
   float gdist=a->GCDistance(b);
   float adist=a->ApproxDistance(b);
   float azimuth=a->GCAzimuth(b);

   mapping alternate = alt(output["ICAO2"],1.000,DB);

/* more mapping for templace process */
   output["DIST_KM"] = sprintf("%.2f",gdist);
   output["DIST_MI"] = sprintf("%.2f",gdist*0.62);
   output["DIST_NM"] = sprintf("%.2f",gdist*0.54);
   output["HEADING"] = sprintf("%.2f",azimuth);
   output["TIME"]    = time_now()->time;
   output["DATE"]    = time_now()->date;

/* wind ...wind ...wind */
   float RAD = 0.01745329;
   float ALPHA = RAD*( 180 - ( (int) ini->WD - (int)output->HEADING) );
   float CWIND = (int) ini->WS*sin(ALPHA);
   float WCA =  (asin( CWIND/ (int) AC[ac]->TAS) /RAD);
   float TWIND = (int) ini->WS*cos(ALPHA);
   float ETAS  = (int) AC[ac]->TAS*cos(WCA*RAD);
   float GS    = ETAS + TWIND;
   output["WCA"] = (string) WCA;
   output["GS"]    = (string) sprintf("%.2f",GS);
   float miles_per_min = 60.0/(float)AC[ac]->TAS;
   output["FLIGHTTIME"]  = (string) sprintf("%.0f",((float)miles_per_min * (float)output->DIST_NM));
   output["miles_per_min"] =(string) miles_per_min;


/* write prased template as html file  */
   output["tpl_filename"] =("plans/"+output->ICAO1+"-"+output->ICAO2+"-"+time()+".html");
   output["map_filename"] =(output->ICAO1+"-"+output->ICAO2+".jpg");

/* template parser */
   string tpl = Stdio.FILE(ini->HTMLDIR+"/"+ini->ROUTETPL)->read();
   foreach(indices(output),string l )
    {
     string t1=  "%"+l+"%";
     string t2=  output[l];
     tpl = replace(tpl,t1,  t2);
    }
   string alternate_replace ="";
   string imgmap ="";
   string altname ="";

   foreach(indices(alternate),string l )
    {
     altname = replace(replace(GetICAOdata(l,DB)->name,"\n",""),"\r","");
     alternate_replace += sprintf ("<tr><td>%s</td><td>%s</td><td>%O nm</td></tr>",
                                  l,altname,
                                  alternate[l]->dist);

      /* IMAGEMAP */
      mapping start = st(alternate[l]->lat,alternate[l]->long,55.0,48.0,6.0,15.0,330.0,448.0);
      int Y1=(int)start->Y;
      int X1=(int)start->X;
      if(Y1+10 > 330.0) Y1=Y1-30;
      if(X1+10 > 448.0) X1=X1-30;
      imgmap += sprintf("<area shape='circle' coords='%s,%s,3' href='/RVSC/route?from=%s&to=%s&ac=%s'"+
                        "onmouseover=\"return overlib('<b>AIRPORT:</b>%s<br/>%s<br/>distance:%s nm');\""+
                        "onmouseout='return nd();'>\n",
                        (string)Y1,(string)X1,output->ICAO1,l,ac,l,altname,(string)alternate[l]->dist);
      }


      mapping nav = navid(from,1.0,DB);
      nav +=  navid(to,1.0,DB);

mapping altx = ([]);
mapping pointer= ([]);
	for(int i=1;i<gdist*0.54/50;i++)
   {
	 pointer = PosFinder(from,a->GCAzimuth(b),(float) i*50 ,DB);
        altx += alt2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB);
	nav += navid2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB);
  }


string tmp_map ="";
foreach(indices(altx),string l )
    {
 	mapping start = st(altx[l]->lat,altx[l]->long,55.0,48.0,6.0,15.0,330.0,448.0);
      int Y1=(int)start->Y;
      int X1=(int)start->X;
      if(Y1+10 > 330.0) Y1=Y1-30;
      if(X1+10 > 448.0) X1=X1-30;
           altname = replace(replace(GetICAOdata(l,DB)->name,"\n",""),"\r","");
     tmp_map=sprintf("<area shape='circle' coords='%s,%s,3' href='/RVSC/route?from=%s&to=%s&ac=%s'"+
                        "onmouseover=\"return overlib('<b>AIRPORT:</b>%s<br/>%s<br/>distance:%s nm');\""+
                        "onmouseout='return nd();'>\n",
                        (string)Y1,(string)X1,output->ICAO1,l,ac,l,altname,(string)altx[l]->dist);
	imgmap += tmp_map;

      }


      foreach(indices(nav),string l )
        {

         mapping start = st(nav[l]->WGS_DLAT,nav[l]->WGS_DLONG,55.0,48.0,6.0,15.0,330.0,448.0);
          int Y1=(int)start->Y+5;
          int X1=(int)start->X+5;

          if(Y1+10 > 330.0) Y1=Y1-30;
          if(X1+10 > 448.0) X1=X1-30;


         imgmap += sprintf("<area shape='circle' coords='%s,%s,3' href='javascript:void(0);'"+
                            "onmouseover=\"return overlib('<b>NAVID :</b>%s / %s (Type: %s)<br/>NAME: %s<br/>FREQ:%s<br/>AIRPORT: %s');\""+
                            "onmouseout='return nd();'>\n", (string)Y1,(string)X1,l, nav[l]->ICAO,  (string)nav[l]->TYPE, nav[l]->NAME, (string)nav[l]->FREQ,nav[l]->ARPT_ICAO );



        }
      
   tpl = replace(tpl,"{ALTERNATE}",alternate_replace);
   tpl = replace(tpl,"{IMGMAP}",imgmap);




   
   write("[%s %s] process route from %O to %O for %O \n",time_now()->date,time_now()->time,output->ICAO1,output->ICAO2,sprintf("%02s",ini->NAME));
return tpl;
}
