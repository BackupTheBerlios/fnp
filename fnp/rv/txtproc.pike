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



mapping GetICAOdata(string icao,mapping db)
{
 mapping ret=([]);
 foreach(indices(db), string l)
{
if(l == icao) {

 ret["name"] = replace(replace(db[icao]->name,"\n",""),"\r","");
 ret["lat"]  = replace(replace(db[icao]->lat,"\n",""),"\r","");
 ret["long"]  = replace(replace(db[icao]->long,"\n",""),"\r","");
 ret["runway"]  = "";
  ret["id"]  = replace(replace(db[icao]->id,"\n",""),"\r","");

 return ret;
}
}
ret["error"] = "1";
return ret;

}



mapping time_now()
{
 mapping ret=([]);
 mapping t1=localtime(time());
 ret["time"] = sprintf("%02d:%02d:%02d",t1->hour,t1->min,t1->sec);
 ret["date"] = sprintf("%02d/%02d/%04d",t1->mday,t1->mon+1,t1->year+1900);
 return ret;
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

int CheckInputICAO(string icao)
 {
  if (strlen(icao) != 4) {return 2;}
  if (sscanf(icao, "%*[A-Z]%1*s") == 2) {return 2;}
  if (sscanf(icao, "%*[A-Z]%1*s") == 1) {return 1;}
 }


 string Send_Error(string error)
 {
   mapping ini = read_setings("settings.ini");
   string tpl = Stdio.FILE(ini->HTMLDIR+"/"+ini->ERRORTPL)->read();
   tpl = replace(tpl,"%ERROR-MESSAGE%",  error);
   write("[%s %s] ERROR -> %s\n",time_now()->date,time_now()->time,error);
   return (string) tpl;

 }

 string serv_file(string file)
 {
  mapping ini = read_setings("settings.ini");
  file = sprintf("%s/%s",ini->HTMLDIR,basename(file));
  if(Stdio.exist(file))  return Stdio.FILE(file)->read();
  return "404";
 }

 mapping st(float lat,float long,float N,float S, float W,float O,float width,float height)
{
    mapping pos=([]);
    pos["argv"] = sprintf("lat=%O, long=%O, N=%O,S=%O W=%O, O=%O, width=%O, height=%O",lat,long,N,S,W,O,width,height);
    pos["geo_breite"] =  O-W;
    pos["Y1"] =  pos->geo_breite/width;
    pos["Y2"] = long-W;
    pos["Y"] =pos->Y2/pos->Y1;
    pos["geo_hoehe"] =  N-S;
    pos["X1"] =  pos->geo_hoehe/height;
    pos["X2"] =N-lat;
    pos["X"] =pos->X2/pos->X1;
    
 return pos;
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


