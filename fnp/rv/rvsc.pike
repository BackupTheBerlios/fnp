#include "Geo.pike";               /* include geo stuff  */
#include "txtproc.pike";           /* include textprocess tools*/
#include "Img.pike";               /* include image processor   */
#include "Alternate.pike";         /* include Alternate airport finder   */



int main(int argc, array(string) argv)
{
/*read the settings file*/
 mapping ini = read_setings("settings.ini");

/* open database, print welcome screen, eval ICAO input */
 array DB = OpenDatabase("iat");
 array route = enter(DB);
 if(!route) return 0;


/* input OK! create mappings for (template) */
 mapping output=([]);

   output["INI_NAME"] =(string)  ini->NAME;;
   output["INI_TAS"] = (string) ini->TAS;
   output["INI_WD"] = (string) ini->WD;
   output["INI_WS"] = (string) ini->WS;



   output["ICAO1"] = route[0];
   output["ICAO2"] = route[1];
   output["NAME1"] = replace(replace(GetICAOdata(route[0],DB)->name,"\n",""),"\r","");
   output["NAME2"] = replace(replace(GetICAOdata(route[1],DB)->name,"\n",""),"\r","");
   output["RWY1"] =  replace(replace(GetICAOdata(route[0],DB)->runway,"\n",""),"\r","");
   output["RWY2"] =  replace(replace(GetICAOdata(route[1],DB)->runway,"\n",""),"\r","");

/* set lat and long data values as float */
 float t_1 =  (float) GetICAOdata(route[0],DB)->lat;
 float t_2 =  (float) GetICAOdata(route[0],DB)->long;
 float t_3 =  (float) GetICAOdata(route[1],DB)->lat;
 float t_4 =  (float) GetICAOdata(route[1],DB)->long;
 output["LAT1"] = (string)t_1;
 output["LONG1"] =(string) t_2;
 output["LAT2"] = (string)t_3;
 output["LONG2"] = (string)t_4;



/* calculate distance/ geovals / TrueCourse */
 object a=Geo(t_1,t_2);
 object b=Geo(t_3,t_4);
  float gdist=a->GCDistance(b);
  float adist=a->ApproxDistance(b);
  float azimuth=a->GCAzimuth(b);

/* CALL ALTERNATES */

mapping alternate = alt((float)output["LAT2"],(float)output["LONG2"],1.000);

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
 output["map_filename"] =(output->ICAO1+"-"+output->ICAO2+"-"+time()+".jpg");

    /* template parser */
 string tpl = Stdio.FILE("rv/html.tbl")->read();
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

 output["write_tpl"] = Stdio.write_file(output->tpl_filename,tpl);
                       Stdio.write_file("plans/x.html",tpl); /* write x.html copy*/

 output["latest_redirect"] = sprintf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0; URL=%s\">",output->tpl_filename);
 output["write_tpl"] = Stdio.write_file("latest.html",output->latest_redirect);
 dirlist("plans/","plans/browse.html"); /* execute dirlist  (create overview of all plans)*/

/*generate map*/
 map(t_1,t_2,t_3,t_4,"plans/"+output->map_filename,output->ICAO1,output->ICAO2, alternate );
 write("%O,%O,%O,%O,%O,%O;%O,%O",t_1,t_2,t_3,t_4,"plans/"+output->map_filename,output->ICAO1,output->ICAO2, alternate );
/* good night! */
 write("\n DONE  \n");

}

