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


  if(file == "/") ret = Stdio.FILE(ini->HTMLDIR+"/"+ini->STARTPAGE)->read();  type = "text/html";
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

 string parsed_ret =  preparser(ret,request->query);  
 request->response_and_finish(([ "data": parsed_ret, "type":type ]));
 }
 write("[%s %s] REQUEST %s -> %s\n",time_now()->date,time_now()->time,ip,request->not_query);


}



string preparser(string x,string query)

{

mapping vals =([]);
vals["VERSION"] = Stdio.FILE("version.txt")->read();

    
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
 mapping DB = OpenDatabase("iat");
 string from = upper_case(query->from);
 string to = upper_case(query->to);
 string E="OK";
  if(CheckInputICAO(from) != 1) return (string)  from+" not a valid ICAO id";
  if(CheckInputICAO(to) != 1)   return (string)  to+" not a valid ICAO id";
  if(from == to)return (string) " departure and destination the same code ";
  if(GetICAOdata(from,DB)->error) return (string)  from+" not a valid ICAO id";
  if(GetICAOdata(to,DB)->error) return (string)  to+" not a valid ICAO id";
  if(E != "OK") return (string) E;

return router(from,to,DB);

}



string  router(string from,string to, mapping DB)
  {
  mapping ini = read_setings("settings.ini");
  mapping output=([]);
   output["INI_NAME"] =(string)  ini->NAME;
   output["INI_TAS"] = (string) ini->TAS;
   output["INI_WD"] = (string) ini->WD;
   output["INI_WS"] = (string) ini->WS;
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
   float WCA =  (asin( CWIND/ (int) ini->TAS) /RAD);
   float TWIND = (int) ini->WS*cos(ALPHA);
   float ETAS  = (int) ini->TAS*cos(WCA*RAD);
   float GS    = ETAS + TWIND;
   output["WCA"] = (string) WCA;
   output["GS"]    = (string) sprintf("%.2f",GS);
   float miles_per_min = 60.0/(float)ini->TAS;
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
   foreach(indices(alternate),string l )
    {
     alternate_replace += sprintf ("<tr><td>%s</td><td>%s</td><td>%O nm</td></tr>",
                                  l,replace(replace(GetICAOdata(l,DB)->name,"\n",""),"\r",""),
                                  alternate[l]->dist);
    }
   tpl = replace(tpl,"{ALTERNATE}",alternate_replace);
   write("[%s %s] process route from %O to %O for %O \n",time_now()->date,time_now()->time,output->ICAO1,output->ICAO2,sprintf("%02s",ini->NAME));
return tpl;
}