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






class Geo {
  class Point {
    float lat;
    float lon;
  }
  float DE2RA=0.01745329252;
  float RA2DE=57.2957795129;
  float ERAD=6378.135;
  float ERADM=6378135.0;
  float AVG_ERAD=6371.0;
  float FLATTENING=1.0/298.26; // earth flattening (wgs '72)
  float EPS=0.000000000005;
  float JM2MI=0.621371;

  object pt;
  void create(void|float|object g, void|float h) {
    pt=Point();
    if (floatp(g) && floatp(h)) {
      pt->lat=g;
      pt->lon=h;
    } else if (has_index(g,"Point")) {
      pt->lat=g->point->lat;
      pt->lon=g->point->lon;
    } else if (object_variablep(g,"lat")) {
      pt->lat=g->lat;                           
      pt->lon=g->lon;
    } else {
      pt->lat=pt->lon=0;
    }
  }
  float GCDistance(object g) {
    if (!has_index(g,"Point")) {
      return 0.0;
    }
    float lat1=pt->lat*DE2RA;
    float lon1=pt->lon*DE2RA;
    float lat2=g->pt->lat*DE2RA;
    float lon2=g->pt->lon*DE2RA;
    float d=sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon1-lon2);
    return (AVG_ERAD*acos(d));
  }
  float ApproxDistance(object g) {
    if (!has_index(g,"Point")) {
      return 0.0;
    }
    float lat1=DE2RA*pt->lat;
    float lon1=-DE2RA*pt->lon;
    float lat2=DE2RA*g->pt->lat;
    float lon2=-DE2RA*g->pt->lon;

    float F=(lat1+lat2)/2.0;
    float G=(lat1-lat2)/2.0;
    float L=(lon1-lon2)/2.0;

    float sing=sin(G);
    float cosl=cos(L);
    float cosf=cos(F);
    float sinl=sin(L);
    float sinf=sin(F);
    float cosg=cos(G);

    float S=sing*sing*cosl*cosl+cosf*cosf*sinl*sinl;
    float C=cosg*cosg*cosl*cosl+sinf*sinf*sinl*sinl;
    float W=atan2(sqrt(S),sqrt(C));
    float R=sqrt((S*C))/W;
    float H1=(3*R-1.0)/(2.0*C);
    float H2=(3*R+1.0)/(2.0*S);
    float D=(2*W*ERAD);
    return (D*(1+FLATTENING*H1*sinf*sinf*cosg*cosg-
  FLATTENING*H2*cosf*cosf*sing*sing));
  }
  float GCAzimuth(object g) {
    if (!has_index(g,"Point"))
      return 0.0;

    float result=0.0;
    int ilat1=(0.50+pt->lat*360000.0);
    int ilat2=(0.50+g->pt->lat*360000.0);
    int ilon1=(0.50+pt->lon*360000.0);
    int ilon2=(0.50+g->pt->lon*360000.0);

    float lat1=DE2RA*pt->lat;
    float lon1=DE2RA*pt->lon;
    float lat2=DE2RA*g->pt->lat;
    float lon2=DE2RA*g->pt->lon;

    if ((ilat1==ilat2)&&(ilon1==ilon2))
      return result;
    else if (ilat1==ilat2) {
      if (ilon1>ilon2)
        result=90.0;
      else
        result=270.0;
    } else if (ilon1==ilon2) {
      if (ilat1>ilat2)
        result=180.0;
    } else {
      float c=acos(sin(lat2)*sin(lat1)+cos(lat2)*cos(lat1)*cos((lon2-lon1)));
      float A=asin(cos(lat2)*sin((lon2-lon1))/sin(c));
      result=(A*RA2DE);

      if ((ilat2>ilat1)&&(ilon2>ilon1)) {
      } else if ((ilat2<ilat1)&&(ilon2<ilon1)) {
        result=180.0-result;
      } else if ((ilat2<ilat1)&&(ilon2>ilon1)) {
        result=180.0-result;
      } else if ((ilat2>ilat1)&&(ilon2<ilon1)) {
        result+=360.0;
      }
    }
    return result;
  }
}

mapping alt(string icao, float range,mapping db)
{
   float lat =(float) db[icao]->lat;
   float long =(float)db[icao]->long;
   return  alt2(lat,long,range,db);
}

mapping alt2(float lat,float long, float range,mapping db)

{
 mapping tmp=([]);
  mapping ret=([]);
  foreach(indices(db), string l)
  {
    if( (float) db[l]->long > long - range && (float) db[l]->long < long + range) tmp[l] +=(["long": (float) db[l]->long ]);
    if ( (float) db[l]->lat > lat - range && (float) db[l]->lat < lat + range) tmp[l] +=(["lat": (float) db[l]->lat ]);
  }      /*runway filter  missing.*/

  foreach(indices(tmp),string l )
  {
   if(tmp[l]->lat && tmp[l]->long )
   {
    object a=Geo(tmp[l]->lat,tmp[l]->long);
    object b=Geo(lat,long);
    if(a->GCDistance(b) >10)
    {
     ret[l] +=(["lat": tmp[l]->lat ]);
     ret[l] +=(["long": tmp[l]->long ]);
     ret[l] +=(["dist": (int)a->GCDistance(b) ]); /*runway informations missing.*/
    }
   }
  }
return ret;
}


mapping navid(string icao, float range,mapping db)
{
  float lat =(float) db[icao]->lat;
  float long =(float)db[icao]->long;
  return navid2( lat, long,  range, db);
}


mapping navid2(float lat,float long, float range,mapping db)
{
  mapping nav= OpenDatabase_NAV();
  mapping tmp=([]);
  mapping ret=([]);

  foreach(indices(nav), string l)
  {

    if( (float) nav[l]->WGS_DLONG > long - range && (float) nav[l]->WGS_DLONG < long + range)
    { tmp[l] +=(["WGS_DLONG": (float) nav[l]->WGS_DLONG ]);}

    if( (float) nav[l]->WGS_DLAT > lat - range && (float) nav[l]->WGS_DLAT < lat + range)
    {tmp[l] +=(["WGS_DLAT": (float) nav[l]->WGS_DLAT ]);}

  }

 foreach(indices(tmp),string l )
  {
   if(tmp[l]->WGS_DLAT && tmp[l]->WGS_DLONG )
   {

    object a=Geo(tmp[l]->WGS_DLAT,tmp[l]->WGS_DLONG);
    object b=Geo(lat,long);
    if(a->GCDistance(b) >0)
   {
     ret[l] +=(["WGS_DLAT": tmp[l]->WGS_DLAT ]);
     ret[l] +=(["WGS_DLONG": tmp[l]->WGS_DLONG ]);
     ret[l] +=(["NAME": nav[l]->NAME]);
     ret[l] +=(["FREQ": nav[l]->FREQ ]);
     ret[l] +=(["STATE_PROV": nav[l]->STATE_PROV]);
     ret[l] +=(["ICAO": nav[l]->ICAO ]);
     ret[l] +=(["TYPE": nav[l]->TYPE ]);
     ret[l] +=(["ARPT_ICAO": nav[l]->ARPT_ICAO ]);

   }
   }
  }
  return ret;
}



mapping PosFinder(string icao, float  tc,float dist,mapping db)
{
/* this function calculates the position given by startpoint with distance and heading*/

 float dlat =(float) db[icao]->lat;
 float dlon =(float) db[icao]->long;


return PosFinder2(dlat,dlon,tc,dist,db);
}
mapping PosFinder2(float dlat,float dlon, float  tc,float dist,mapping db)
{


float pi=3.1415926535;
dlat = (pi/180)*dlat; /* dlat To Radians */
dlon = (pi/180)*dlon; /* dlon To Radians */
tc= (pi/180)*tc; /*course to radians */
dist =  (dist*pi/(180*60));


if(dlat >0) dlat=asin(sin(dlat)*cos(dist)+cos(dlat)*sin(dist)*cos(tc));
if(dlat <0) dlat=asin(sin(dlat)*cos(dist)-cos(dlat)*sin(dist)*cos(tc));
if(dlon >0) dlon=dlon+asin(sin(tc)*sin(dist)/cos(dlat));
if(dlon <0) dlon=dlon-asin(sin(tc)*sin(dist)/cos(dlat));


mapping ret=([]);

ret["rlon"] = dlon;
ret["rlat"] = dlat;
ret["WGS_DLAT"] = (180/pi)*dlat;
ret["WGS_DLONG"] = (180/pi)*dlon;
return ret;
}


string get_codes(string c)
{
 mapping ini = read_setings("settings.ini");
 mapping codes = find_codes(c);

 /*parse template*/
 string tpl = Stdio.FILE(ini->HTMLDIR+"/"+ini->FINDER_RESTPL)->read();
 string x="";
 sscanf(tpl, "%*s{LIST}%[^{LIST}]",string tpl1);
 foreach (indices(codes), string l) x += replace(replace(tpl1,"%airport%",codes[l]),"%icao%",l);
 x = replace(replace(x,"%airport%",""),"%icao%","");
 string t1 = sprintf ("{LIST}%s{LIST}",tpl1);
 string t2 = replace(tpl,t1,x);
return t2;
}

mapping find_codes(string c)
{
  mapping ini = read_setings("settings.ini");
  mapping ret=([]);
  mapping DB = OpenDatabase("spt");

  foreach(indices(DB), string l)
   {
   if( (string) DB[l]->id[0..1] == c) ret[l] =  replace(replace(DB[l]->name,"\n",""),"\r","");

  }
return ret;
}




