mapping DB = OpenDatabase("globalairports");  /* Load database airports */
mapping Aircrafts = Load_AC_DataBase();
mapping nav= OpenDatabase_NAV();

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
   output["INI_NAME"] 	=	(string)  ini->NAME;
   output["INI_WD"] 		= (string) ini->WD;
   output["INI_WS"] 		= (string) ini->WS;
   output["AC-TAS"] 		= (string)  Aircrafts[ac]->TAS;
   output["AC-REG"] 		= (string)  ac;
   output["AC-TYPE"] 		= (string)  Aircrafts[ac]->TYPE;
   output["AC-MOTW"] 		= (string)  Aircrafts[ac]->MOTW;
   output["AC-RANGE"] 	= (string)  Aircrafts[ac]->RANGE;
   output["AC-RMK"] 		= (string)  Aircrafts[ac]->RMK;
   output["ICAO1"] 			=	(string)	from;
   output["ICAO2"] 			= (string)	to;
   output["NAME1"] 			=	(string)	m_from->name;
   output["NAME2"] 			= (string)	m_to->name;
   output["LAT1"] 			= (string)	m_from->lat;
	 output["LONG1"] 			=	(string) 	m_from->long;
   output["LAT2"] 			= (string)	m_to->lat;
   output["LONG2"] 			= (string)	m_to->long;

   object a							=	Geo( (float) m_from->lat, (float) m_from->long);
   object b							=	Geo( (float) m_to->lat  , (float) m_to->long);
	 float gdist					=	a->GCDistance(b);
   float adist					=	a->ApproxDistance(b);
   float azimuth				=	a->GCAzimuth(b);
   output["DIST_KM"] 		= sprintf("%.2f",gdist);
   output["DIST_MI"] 		= sprintf("%.2f",gdist*0.62);
   output["DIST_NM"] 		= sprintf("%.2f",gdist*0.54);
   output["HEADING"] 		= sprintf("%.2f",azimuth);
   output["TIME"]    		= time_now()->time;
   output["DATE"]    		= time_now()->date;

Push_Log(sess,sprintf("Distance: %s, Heading: %s",output["DIST_NM"],output["HEADING"]));

   float 	RAD 					= 0.01745329;
   float ALPHA 					= RAD*( 180 - ( (int) ini->WD - (int)output->HEADING) );
   float CWIND 					= (int) ini->WS*sin(ALPHA);
   float WCA 						= (asin( CWIND/ (int) Aircrafts[ac]->TAS) /RAD);
   float TWIND 					= (int) ini->WS*cos(ALPHA);
   float ETAS  					= (int) Aircrafts[ac]->TAS*cos(WCA*RAD);
   float GS    					= ETAS + TWIND;
   output["WCA"]			 	= (string) WCA;
   output["GS"]    			= (string) sprintf("%.2f",GS);
   float miles_per_min 	= 60.0/(float)Aircrafts[ac]->TAS;
   output["FLIGHTTIME"] = (string) sprintf("%.0f",((float)miles_per_min * (float)output->DIST_NM));
   output["mn_per_min"] =	(string) miles_per_min;

Push_Log(sess,sprintf("GS: %s WCA: %s, TAS: %s.",output["GS"],output["WCA"],output["AC-TAS"]));
Push_Log(sess,sprintf("Flighttime: %s min.",output["FLIGHTTIME"]));


mapping Alt = alt(output["ICAO2"],1.000,DB);
Push_Log(sess,sprintf("Found %d Alternates for %s",sizeof(indices(Alt)),output["ICAO2"]));

foreach(indices(Alt),string l) { output["Alt_"+l] =(["lat":	Alt[l]->lat, "long": Alt[l]->long, "dist":Alt[l]->dist ]); }




	mapping pointer	= ([]);
	mapping NavID		=	([]);
	for(int i=1;i<gdist*0.54/50;i++)
   {
	 pointer = PosFinder(from,a->GCAzimuth(b),(float) i*50 ,DB);
        Alt += alt2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB);
	NavID += navid2(pointer->WGS_DLAT,pointer->WGS_DLONG,0.300,DB,nav);
  }


Push_Log(sess,sprintf("Found %d En-Route Alternates",sizeof(indices(Alt))));
foreach(indices(Alt),string l) { output["Alt_"+l] =(["lat":	Alt[l]->lat, "long": Alt[l]->long, "dist":Alt[l]->dist ]); }

Push_Log(sess,sprintf("Found %d En-Route NavID's",sizeof(indices(NavID))));
foreach(indices(NavID),string l) { output["Nav_"+l] =(["name":	NavID[l]->NAME, "type": NavID[l]->TYPE, "lat": NavID[l]->WGS_DLAT,
																	"long": NavID[l]->WGS_DLONG, "freq":NavID[l]->FREQ, "arpt": NavID[l]->ARPT_ICAO]); }







write("\n%O\n",output);






return "hallo";

}












