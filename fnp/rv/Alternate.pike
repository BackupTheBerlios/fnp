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
  }

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
     ret[l] +=(["dist": (int)a->GCDistance(b) ]);
    }
   }
  }
 return ret;
}

