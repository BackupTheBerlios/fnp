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
  }
  return ret;
 }
string serv_file(string file)
 {
  mapping ini = read_setings("settings.ini");
  file = sprintf("%s/%s",ini->HTMLDIR,basename(file));
  if(Stdio.exist(file))  return Stdio.FILE(file)->read();
  return "404";
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