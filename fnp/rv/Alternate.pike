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


