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

 string brake(int l){ for (int a=0;a<l;a++)write("#");  write("\n");}
string nl(int l){if(l)for (int a=0;a<l;a++) write("\n"); }





/*


string from,to,tmp,namef,namet;
array i;
float lat1,lat2,lon1,lon2;

from ="EDDM";
to ="EDHK";

i=(Stdio.FILE("rv/iat.txt")->read())/"\n";

lat1 = (float) dbq(i,from+" Lat: ");
lon1 = (float) dbq(i,from+" Long: ");
namef =        dbq(i,from+" Name: ");
lat2 = (float) dbq(i,to+" Lat: ");
lon2 = (float) dbq(i,to+" Long: ");
namet =   dbq(i,to+" Name: ");


write("distance -> %O",distance(lat1,lon1,lat2,lon2)*1.852);
write("heading -> %O",heading(lat1,lon1,lat2,lon2,distance(lat1,lon1,lat2,lon2)));
nl(1);
write("%O %O %O %O",lat1,lon1,lat2,lon2);

}

float heading(float lat1, float lon1, float lat2, float lon2,int dist)
{
 float dist =(float) dist;
 return asin(sin(lon2 - lon1) * cos(lat2) / sin(dist / 60) )* 3.1415926535898   / 180;
}


float con_f(string f)
{
 float f  = (float) replace(f," ","");
 return  f;
}

string dbq(array f,string s)
{
 foreach (f, string d)
  {
   if(d[0..sizeof(s)-1] == s){return   replace(d,s,"");  }
  }
}

string brake(int l){ for (int a=0;a<l;a++)write("#");  write("\n");}
string nl(int l){if(l)for (int a=0;a<l;a++) write("\n"); }


  */