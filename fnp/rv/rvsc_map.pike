
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

string rvsc_map(mapping query)
{
  mapping ini = read_setings("settings.ini");
  mapping DB = OpenDatabase(ini->DB);
  string from = upper_case(query->from);
  string to = upper_case(query->to);

    string E="OK";
    if(CheckInputICAO(from) != 1) E = from+" not a valid ICAO id";
    if(CheckInputICAO(to) != 1)   E =  to+" not a valid ICAO id";
    if(from == to)E = " departure and destination the same code ";
    if(!GetICAOdata(from,DB)->name) E =  from+" not a valid ICAO id";
    if(!GetICAOdata(to,DB)->name) E =  to+" not a valid ICAO id";
    if(E != "OK") return 0;

   float s1 =  (float) GetICAOdata(from,DB)->lat;
   float s2 =  (float) GetICAOdata(from,DB)->long;
   float e1 =  (float) GetICAOdata(to,DB)->lat;
   float e2 =  (float) GetICAOdata(to,DB)->long;
   float map_w = 330.0;
   float map_h = 448.0;

    mapping start = st(s1,s2,55.0,48.0,6.0,15.0,map_w,map_h);
    mapping end = st(e1,e2,55.0,48.0,6.0,15.0,map_w,map_h);

    int Y1=(int)start->Y;
    int X1=(int)start->X;
    int Y2=(int)end->Y;
    int X2=(int)end->X;

  object img =Image.load("rv/germany.map");
    if(Y1+10 > map_w) Y1=Y1-30;
    if(Y2+10 > map_w) Y2=Y2-30;
    if(X1+10 > map_h) X1=X1-30;
    if(X2+10 > map_h) X2=X2-30;
      img->line(Y1,X1,Y2,X2, 255,0,0); /*routeline*/
      img->circle(Y1,X1,4,4,0,0,255);  /*start circle*/
      img->circle(Y2,X2,4,4,0,0,255);  /*end circle*/
      img=img->paste_alpha_color(Image.Font()->write(from),0,0,255,Y1+4,X1+4 ); /*ICAO name from */
      img=img->paste_alpha_color(Image.Font()->write(to),0,0,255,Y2+4,X2+4 );   /*ICAO name to */
      img=img->paste_alpha_color(Image.Font()->write(time_now()->date+" "+time_now()->time),0,0,0,1,1 ); /*time / date info*/
      img=img->paste_alpha_color(Image.Font()->write(from + "-" + to),0,0,0,1,12 );   /*infotext*/
      img=img->paste_alpha_color(Image.Font()->write("alternates"),255,0,255,1,24 );  //

 
/*ALTERNATES */
mapping alt = alt(to,1.000,DB);
      img=img->paste_alpha_color(Image.Font()->write("_not_valid_for_navigation_"),255,0,0,1,435 );
      foreach(indices(alt),string l )
        {
         mapping start = st(alt[l]->lat,alt[l]->long,55.0,48.0,6.0,15.0,map_w,map_h);
          int Y1=(int)start->Y;
          int X1=(int)start->X;
          if(Y1+10 > map_w) Y1=Y1-30;
          if(X1+10 > map_h) X1=X1-30;
          img->circle(Y1,X1,2,2,255,0,255);
          img->circle(Y1,X1,1,1,255,0,255);
        }


 return Image.JPEG.encode(img);
}



