mapping alt(string icao, float range,mapping db)
{
  mapping tmp=([]);
  mapping ret=([]);
    float lat =(float) db[icao]->lat;
    float long =(float)db[icao]->long;
                                   
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

  mapping nav= OpenDatabase_NAV();
  mapping tmp=([]);
  mapping ret=([]);
    float lat =(float) db[icao]->lat;
    float long =(float)db[icao]->long;

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
   // write("%O",ret);
 return ret;
}





