mapping OpenDatabase(string f)
{
  array fx = (Stdio.FILE("db/world")->read())/"\n";
  mapping db=([]);

  foreach(fx,string l)
  {
   array x = l/"|";
   if(sizeof(x[1]) ==4 )   db[x[1]]= (["ser": x[2] ,"name":x[3], "lat":x[4], "long":x[5] ]);
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
   return (string) tpl;      
 }
