/*
#include "txtproc.pike";

int main()
{get_codes("HK");}

*/
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
{   mapping ini = read_setings("settings.ini");
  mapping ret=([]);
  mapping DB = OpenDatabase(ini->DB_APT);

  foreach(indices(DB), string l)
   {
   if(DB[l]->ser[0..1] == c) ret[l] =  replace(replace(DB[l]->name,"\n",""),"\r","");
  }
return ret;
}


