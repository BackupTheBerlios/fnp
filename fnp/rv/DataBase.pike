mapping OpenDatabase(string f)

{
 array fx = (Gz.File("db/apt","rb")->read())/"\n";

  mapping db=([]);

  foreach(fx,string l)
  {
    if(sizeof(l) >2)
   {
   array x = l/"|";
   if(sizeof(x[1]) ==4 )   db[x[1]]= (["id": x[2] ,"name":x[3], "lat":x[4], "long":x[5] ]);
   }
   }
return db;
}

mapping read_setings(string f)
 {
  mapping ret=([]);
  foreach((Stdio.FILE(f)->read())/"\n", string l)
  {
  if(l[0..1] == "U_")
   {
   array t = l/"=";
   ret[replace(t[0],"U_","")] = replace(replace(t[1],"\n",""),"\r","");
   }

   if(l[0..1] == "S_")
   {
   array t = l/"=";
   ret[replace(t[0],"S_","")] = replace(replace(t[1],"\n",""),"\r","");
   }
   if(l[0..2] == "DB_")
   {
   array t = l/"=";
   ret[replace(t[0],"DB_","")] = replace(replace(t[1],"\n",""),"\r","");
   }

   if(l[0..3] == "TPL_")
   {
   array t = l/"=";
   ret[replace(t[0],"TPL_","")] = replace(replace(t[1],"\n",""),"\r","");
   }

	}
	return ret;
 }






 mapping Load_AC_DataBase()
{
  array fx = (Stdio.FILE("db/ac")->read())/"\n";
  mapping db=([]);
  array x;
  foreach(fx,string l)
  {
   if(l[0..1] != "#"  && sizeof(l) > 10) {
      x = l/":";
      //write("%O\n",l);
  db[x[0]] += ([ x[1] : x[2] ]);
     }
   }
return db;
}

mapping OpenDatabase_NAV()
{
 array fx = (Gz.File("db/nav","rb")->read())/"\n";
 mapping db=([]);
 foreach(fx,string l)
  {
   array x = l/"|";
   if(sizeof(l) >20)
   {
    db[x[1]]= ([ "NAV_IDENT"    :x[1],
    "TYPE"         :x[2],
    "CTRY"         :x[3],
    "NAV_KEY_CD"   :x[4],
    "STATE_PROV"   :x[5],
    "NAME"         :x[6],
    "ICAO"         :x[7],
    "WAC"          :x[8],
    "FREQ"         :x[9],
    "USAGE_CD"     :x[10],
    "CHAN"         :x[11],
    "RCC"          :x[12],
    "FREQ_PROT"    :x[13],
    "POWER"        :x[14],
    "NAV_RANGE"    :x[15],
    "LOC_HDATUM"   :x[16],
    "WGS_DATUM"    :x[17],
    "WGS_LAT"      :x[18],
    "WGS_DLAT"     :x[19],
    "WGS_LONG"     :x[20],
    "WGS_DLONG"    :x[21],
    "SLAVED_VAR"   :x[22],
    "MAG_VAR"      :x[23],
    "ELEV"         :x[24],
    "DME_WGS_LAT"  :x[25],
    "DME_WGS_DLAT" :x[26],
    "DME_WGS_LONG" :x[27],
    "DME_WGS_DLONG":x[28],
    "DME_ELEV"     :x[29],
    "ARPT_ICAO"    :x[30],
    "OS"           :x[31],
    "CYCLE_DATE"   :x[32] ]);
   }
 }
return db;
}


mapping OpenDatabase_WPT()
{
 array fx = (Gz.File("db/wpt","rb")->read())/"\n";
 mapping db=([]);
 foreach(fx,string l)
  {
   array x = l/"\t";
	 if(sizeof(l) >20)
   {
	 	 db[x[0]] +=([
		 	"WGS_DLAT": 	replace(replace(x[14]	,"\n",""),"\r",""),
     	"WGS_DLONG": 	replace(replace(x[16]	,"\n",""),"\r",""),
     	"DESC": 			replace(replace(x[5]	,"\n",""),"\r",""),
     	"ICAO":				replace(replace(x[6]	,"\n",""),"\r",""),
     	"TYPE": 			replace(replace(x[4]	,"\n",""),"\r","")
			]);
	}
 }
return db;
}


mapping OpenDatabase_RWY()
{
 array fx = (Gz.File("db/rwy","rb")->read())/"\n";
 mapping db=([]);
 foreach(fx,string l)
  {
   array x = l/"|";
	 if(sizeof(l) >20)
   {
	 	 db[x[1]+"_"+x[2]] +=([
		 	"ID": 			replace(replace(x[1]	,"\n",""),"\r",""),
			"RWY":			replace(replace(x[2]	,"\n",""),"\r",""),
     	"LENGHT": 	replace(replace(x[3]	,"\n",""),"\r",""),
     	"WIDHT": 		replace(replace(x[4]	,"\n",""),"\r",""),
     	"SURFACE":	replace(replace(x[5]	,"\n",""),"\r","")
			]);
	}
 }
return db;
}



mapping RWY_SUR()
{

mapping x =([
	"ASP": "ASPHALT, ASPHALTIC CONCRETE, MACADAM, OR BITUMEN BOUND MACADAM (INCLUDING ANY OF THESE SURFACE TYPES WITH CONCRETE ENDS)",
	"BIT": "BITUMINOUR, TAR OR ASPHALT MIXED IN PLACE, OILED",
	"CLA": "CLAY",
	"COM": "COMPOSITE, LESS THAN 50 PERCENT OF THE RUNWAY LENGTH IS PERMANENT",
	"CON": "CONCRETE",
	"COP": "COMPOSITE, 50 PERCENT OR MORE OF THE RUNWAY LENGTH IS PERMANENT",
	"COR": "CORAL",
	"GRE": "GRADED OR ROLLED EARTH, GRASS ON GRADED EARTH",
	"GRS": "GRASS OR EARTH NOT GRADED OR ROLLED",
	"GVL": "GRAVEL",
	"ICE": "ICE",
	"LAT": "LATERITE",
	"MAC": "MACADAM - CRUSHED ROCK WATER BOUND",
	"MEM": "MEMBRANE - PLASTIC OR OTHER COATED FIBER MATERIAL",
	"MIX": "MIX IN PLACE USING NONBITUMIOUS BINDERS SUCH AS PORTLAND CEMENT",
	"PEM": "PART CONCRETE, PART ASPHALT, OR PART BITUMEN-BOUND MACADAM",
	"PER": "PERMANENT, SURFACE TYPE UNKNOWN",
	"PSP": "PIECED STEEL PLANKING",
	"SAN": "SAND, GRADED, ROLLED OR OILED",
	"SNO": "SNOW",
	"U"	 : "SURFACE UNKNOWN"]);
return x;
}

