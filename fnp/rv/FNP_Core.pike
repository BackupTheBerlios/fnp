mapping DB = OpenDatabase("globalairports");  /* Load database airports */
mapping Aircrafts = Load_AC_DataBase();
mapping nav= OpenDatabase_NAV();
mapping wpt= OpenDatabase_WPT();

mapping Start_FNP(mapping query,mapping ini)
{

//
//OK ACTION! NEW ROUTE
//

/* check GET/POST values (ICAO from/to and aircraft at least)*/
 mapping ret=([]);
 string from = upper_case(query->from);
 string to = upper_case(query->to);
 string ac = query->ac;
  if(!from) 											return Send_Error("missing from");
	if(!to)													return Send_Error("missing to");
  if(from == to)                  return Send_Error("Departure and Destination the same");
  if(CheckInputICAO(from) != 1)   return Send_Error("\"" + from + "\": Invalid ICAO ID");
  if(CheckInputICAO(to) != 1)     return Send_Error("\"" + to   + "\": Invalid ICAO ID");
  if(GetICAOdata(from,DB)->error) return Send_Error("Airport: \"" + from + "\": Not in Database");
  if(GetICAOdata(to,DB)->error)   return Send_Error("Airport: \"" + to   + "\": Not in Database");
	if(!ac)													return Send_Error("Missing Aircraft");
	if(!Aircrafts[ac])							return Send_Error("Aircraft: \"" + ac + "\": Not in Database");


	/* airports and aircraft input ok. */


	string data = sprintf("<html><head><meta http-equiv=\"Refresh\" content=\"0; url=/FP_%s\"></head></html>",start_session(query));


	ret = (["check": "ok", "data": data, "type": ini["CT-HTML"] ]);
	return ret;

}

mapping Start_FNP_Router(string sess ,mapping ini)
{

debug ("Ok router process rennt....");

return  (["check": "ok", "data": "FERTIG", "type": ini["CT-HTML"] ]);

}

mapping Start_FNP_Holding(string sess,mapping ini)
{
	string data = Stdio.FILE(ini->HTMLDIR+"/"+ini->WAITTPL)->read();
	sess = replace(sess,"/FP_","");
	data = replace(data,"%SESS%",sess);
	return (["check": "ok", "data": data, "type": ini["CT-HTML"] ]);
}

string FNP_Route(string sess,mapping ini)
{

	mapping x = decode_value(Stdio.FILE(combine_path(ini->SESSIONDIR,sess))->read());
		string from 		= (string) upper_case(x->from);
		string to 			= (string) upper_case(x->to);
		string ac 			= (string)x->ac;
 	 	mapping m_from 	= GetICAOdata(from,DB);
   	mapping m_to		=	GetICAOdata(to,DB);
Push_Log(sess,sprintf("Processing %s -> %s with %s ",from,to,ac));


	if(ini->DEMO == "YES") { from =ini->DEMO_F; to =ini->DEMO_T;}
	mapping output=([]);


   output["T_SESSION"] 		=	(string)  sess;;
   output["T_INI_NAME"] 	=	(string)  ini->NAME;
   output["T_INI_WD"] 		= (string) ini->WD;
   output["T_INI_WS"] 		= (string) ini->WS;
   output["T_AC-TAS"] 		= (string)  Aircrafts[ac]->TAS;
   output["T_AC-REG"] 		= (string)  ac;
   output["T_AC-TYPE"] 		= (string)  Aircrafts[ac]->TYPE;
   output["T_AC-MOTW"] 		= (string)  Aircrafts[ac]->MOTW;
   output["T_AC-RANGE"] 	= (string)  Aircrafts[ac]->RANGE;
   output["T_AC-RMK"] 		= (string)  Aircrafts[ac]->RMK;
   output["T_ICAO1"] 			=	(string)	from;
   output["T_ICAO2"] 			= (string)	to;
   output["T_NAME1"] 			=	(string)	m_from->name;
   output["T_NAME2"] 			= (string)	m_to->name;
   output["T_LAT1"] 			= (string)	m_from->lat;
	 output["T_LONG1"] 			=	(string) 	m_from->long;
   output["T_LAT2"] 			= (string)	m_to->lat;
   output["T_LONG2"] 			= (string)	m_to->long;

   object a							=	Geo( (float) m_from->lat, (float) m_from->long);
   object b							=	Geo( (float) m_to->lat  , (float) m_to->long);
	 float gdist					=	a->GCDistance(b);
   float adist					=	a->ApproxDistance(b);
   float azimuth				=	a->GCAzimuth(b);
   output["T_DIST_KM"] 		= sprintf("%.2f",gdist);
   output["T_DIST_MI"] 		= sprintf("%.2f",gdist*0.62);
   output["T_DIST_NM"] 		= sprintf("%.2f",gdist*0.54);
   output["T_HEADING"] 		= sprintf("%.2f",azimuth);
   output["T_TIME"]    		= time_now()->time;
   output["T_DATE"]    		= time_now()->date;

Push_Log(sess,sprintf("Distance: %s, Heading: %s",output["T_DIST_NM"],output["T_HEADING"]));

   float 	RAD 					= 0.01745329;
   float ALPHA 					= RAD*( 180 - ( (int) ini->WD - (int)output->HEADING) );
   float CWIND 					= (int) ini->WS*sin(ALPHA);
   float WCA 						= (asin( CWIND/ (int) Aircrafts[ac]->TAS) /RAD);
   float TWIND 					= (int) ini->WS*cos(ALPHA);
   float ETAS  					= (int) Aircrafts[ac]->TAS*cos(WCA*RAD);
   float GS    					= ETAS + TWIND;
   output["T_WCA"]			 	= (string) WCA;
   output["T_GS"]    			= (string) sprintf("%.2f",GS);
   float miles_per_min 	= 60.0/(float)Aircrafts[ac]->TAS;
   output["T_FLIGHTTIME"] = (string) sprintf("%.0f",((float)miles_per_min * (float)output->DIST_NM));
   output["T_mn_per_min"] =	(string) miles_per_min;

	 Push_Log(sess,sprintf("GS: %s WCA: %s, TAS: %s.",output["T_GS"],output["T_WCA"],output["T_AC-TAS"]));
	 Push_Log(sess,sprintf("Flighttime: %s min.",output["T_FLIGHTTIME"]));


	mapping Alt = alt(output["T_ICAO2"],1.000,DB);
	Push_Log(sess,sprintf("Found %d Alternates for %s",sizeof(indices(Alt)),output["T_ICAO2"]));

	 foreach(indices(Alt),string l) { output["Alt_"+l] =(["lat":	Alt[l]->lat, "long": Alt[l]->long, "dist":Alt[l]->dist ]); }

	mapping pointer	= ([]); mapping NavID		=	([]); mapping WayPoints		=	([]);

	for(int i=1;i<gdist*0.54/25;i++)
   {
	 pointer = PosFinder(from,a->GCAzimuth(b),(float) i*25 ,DB);
     Alt += alt2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB);
		NavID += navid2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB,nav);
		WayPoints += waypoint2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.100,DB,wpt);

  }
		NavID += navid2((float) m_to->lat, (float) m_to->long,0.500,DB,nav);
	WayPoints += waypoint2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.100,DB,wpt);



	Push_Log(sess,sprintf("Found %d En-Route Alternates",sizeof(indices(Alt))));
	 foreach(indices(Alt),string l) { output["Alt_"+l] =(["lat":	Alt[l]->lat, "long": Alt[l]->long, "dist":Alt[l]->dist ]); }


	Push_Log(sess,sprintf("Found %d En-Route Waypoints",sizeof(indices(WayPoints))));
		foreach(indices(WayPoints),string l) { output["Wpt_"+l] = (["lat":	WayPoints[l]->WGS_DLAT, "long": WayPoints[l]->WGS_DLONG, "desc":WayPoints[l]->DESC,
																					"icao": WayPoints[l]->ICAO,  "type": WayPoints[l]->TYPE]);  }

 Push_Log(sess,sprintf("Found %d En-Route NavID's",sizeof(indices(NavID))));

	 foreach(indices(NavID),string l) { output["Nav_"+l] =(["name":	NavID[l]->NAME, "type": NavID[l]->TYPE, "lat": NavID[l]->WGS_DLAT,
																	"long": NavID[l]->WGS_DLONG, "freq":NavID[l]->FREQ, "arpt": NavID[l]->ARPT_ICAO , "icao": NavID[l]->ICAO ]); }



  		string alternate_replace =""; string imgmap =""; string altname ="";
 		foreach(indices(Alt),string l )/* IMAGEMAP  (airports) */
    {
     	altname = replace(replace(GetICAOdata(l,DB)->name,"\n",""),"\r","");
     	alternate_replace += sprintf ("<tr><td>%s</td><td>%s</td><td>%O nm</td></tr>",l,altname,Alt[l]->dist);
      mapping start = st(Alt[l]->lat,Alt[l]->long,55.0,48.0,6.0,15.0,330.0,448.0);
      int Y1=(int)start->Y;
      int X1=(int)start->X;
      if(Y1+10 > 330.0) Y1=Y1-30;
      if(X1+10 > 448.0) X1=X1-30;
      imgmap += sprintf("<area shape='circle' coords='%s,%s,3' href='javascript:void(0);'"+
                        "onmouseover=\"return overlib('<b>AIRPORT:</b>%s<br/>%s<br/>distance:%s nm');\""+
                        "onmouseout='return nd();'>\n",
                        (string)Y1,(string)X1,l,altname,(string)Alt[l]->dist);
   	}


		foreach(indices(NavID),string l )/* IMAGEMAP  (NavIDs) */
    {
     mapping start = st(NavID[l]->WGS_DLAT,NavID[l]->WGS_DLONG,55.0,48.0,6.0,15.0,330.0,448.0);
     int Y1=(int)start->Y+5;
     int X1=(int)start->X+5;
     if(Y1+10 > 330.0) Y1=Y1-30;
     if(X1+10 > 448.0) X1=X1-30;
     imgmap += sprintf("<area shape='circle' coords='%s,%s,2' href='javascript:void(0);'"+
                            "onmouseover=\"return overlib('<b>NAVID :</b>%s / %s (Type: %s)<br/>NAME: %s<br/>FREQ:%s<br/>AIRPORT: %s');\""+
                            "onmouseout='return nd();'>\n", (string)Y1,(string)X1,l, (string)  NavID[l]->icao,(string) NavID[l]->type,
														(string)  NavID[l]->name,	(string)NavID[l]->freq, (string) NavID[l]->arpt );
		}


		foreach(indices(WayPoints),string l )/* IMAGEMAP  (NavIDs) */
    {
     mapping start = st(WayPoints[l]->WGS_DLAT,WayPoints[l]->WGS_DLONG,55.0,48.0,6.0,15.0,330.0,448.0);
     int Y1=(int)start->Y+2;
     int X1=(int)start->X+3;
     if(Y1+10 > 330.0) Y1=Y1-30;
     if(X1+10 > 448.0) X1=X1-30;
     imgmap += sprintf("<area shape='circle' coords='%s,%s,2' href='javascript:void(0);'"+
                            "onmouseover=\"return overlib('<b>WAYPOINT:</b>%s  (Type: %s)<br/>DESC: %s<br/>AIRPORT: %s');\""+
                            "onmouseout='return nd();'>\n", (string)Y1,(string)X1,l, (string)  WayPoints[l]->TYPE ,(string) WayPoints[l]->DESC,
														(string)  WayPoints[l]->ICAO);
		}


		output["T_IMGMAP"] = imgmap;
		output["T_ALTERNATE"] = alternate_replace;

Push_Log(sess,"Scanning map.");
		/* create the map image */
		  float map_w = 330.0;
   		float map_h = 448.0;

    mapping start = st((float) m_from->lat, (float) m_from->long,55.0,48.0,6.0,15.0,map_w,map_h);
    mapping end = st((float) m_to->lat, (float) m_to->long,55.0,48.0,6.0,15.0,map_w,map_h);

    int Y1=(int)start->Y;
    int X1=(int)start->X;
    int Y2=(int)end->Y;
    int X2=(int)end->X;

  object img =Image.load("maps/germany.map");
    if(Y1+10 > map_w) Y1=Y1-30;
    if(Y2+10 > map_w) Y2=Y2-30;
    if(X1+10 > map_h) X1=X1-30;
    if(X2+10 > map_h) X2=X2-30;
      img->line(Y1,X1,Y2,X2, 255,0,0); /*routeline*/
      img->circle(Y1,X1,5,5,0,0,255);  /*start circle*/
      img->circle(Y2,X2,5,5,0,0,255);  /*end circle*/
      img=img->paste_alpha_color(Image.Font()->write(from),0,0,255,Y1+4,X1+4 ); /*ICAO name from */
      img=img->paste_alpha_color(Image.Font()->write(to),0,0,255,Y2+4,X2+4 );   /*ICAO name to */
      img=img->paste_alpha_color(Image.Font()->write(time_now()->date+" "+time_now()->time),0,0,0,1,1 ); /*time / date info*/
      img=img->paste_alpha_color(Image.Font()->write(from + "-" + to),0,0,0,1,12 );   /*infotext*/
			img=img->paste_alpha_color(Image.Font()->write("Alternate Airports"),255,0,255,1,24 );   /*infotext*/
			img=img->paste_alpha_color(Image.Font()->write("NavID's"),0,255,0,1,36 );   /*infotext*/
			img=img->paste_alpha_color(Image.Font()->write("WayPoints"),0,0,255,1,48 );   /*infotext*/




/* ALTERNATES */


      img=img->paste_alpha_color(Image.Font()->write("_not_valid_for_navigation_"),255,0,0,1,435 );

			foreach(indices(Alt),string l )
        {
         mapping start = st(Alt[l]->lat,Alt[l]->long,55.0,48.0,6.0,15.0,map_w,map_h);
          int Y1=(int)start->Y;
          int X1=(int)start->X;
          if(Y1+10 > map_w) Y1=Y1-30;
          if(X1+10 > map_h) X1=X1-30;
          img->circle(Y1,X1,3,3,255,0,255);
        }

      foreach(indices(NavID),string l )
        {
        mapping start = st(NavID[l]->WGS_DLAT,NavID[l]->WGS_DLONG,55.0,48.0,6.0,15.0,map_w,map_h);
          int Y1=(int)start->Y+5;
          int X1=(int)start->X+5;
          if(Y1+10 > map_w) Y1=Y1-30;
          if(X1+10 > map_h) X1=X1-30;
          img->circle(Y1,X1,2,2,0,255,0);
       	}
      foreach(indices(WayPoints),string l )
        {
        mapping start = st(WayPoints[l]->WGS_DLAT,WayPoints[l]->WGS_DLONG,55.0,48.0,6.0,15.0,map_w,map_h);
          int Y1=(int)start->Y+2;
          int X1=(int)start->X+3;
          if(Y1+10 > map_w) Y1=Y1-30;
          if(X1+10 > map_h) X1=X1-30;
          img->circle(Y1,X1,2,2,0,0,255);
       	}




				Stdio.write_file(combine_path(ini->SESSIONDIR,sess+"_route.jpg"),Image.JPEG.encode(img));

Push_Log(sess,"Wrote map.");


Stdio.write_file(combine_path(ini->SESSIONDIR,sess+".fnp.out"),encode_value_canonic(output));

sleep(2);
Push_Log_Done(sess);

return "done";

}

string ServPlanFilePass(string file,mapping ini)
{
 file=combine_path(ini->SESSIONDIR,file);
 if(Stdio.exist(file)) 	return Stdio.FILE(file)->read();
 return "404";

}

string ServPlanFileParse(string file,mapping ini)
{
mapping output = decode_value(Stdio.FILE(combine_path(ini->SESSIONDIR,file+".out"))->read());
 string tpl = Stdio.FILE(ini->HTMLDIR+"/"+ini->ROUTETPL)->read();

 foreach(indices(output),string l )
   {
	 if(l[0..1] == "T_")
	 	{
	  string t1=  (string) "%"+replace(l,"T_","")+"%";
    string t2=  (string) output[l];
    tpl = replace(tpl,t1,  t2);
		}
   }
	return tpl;
}







