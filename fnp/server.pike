#include "rv/main.pike";         /* include main system*/
#include "rv/Geo.pike";          /* include geo stuff */
#include "rv/txtproc.pike";      /* include textprocess tools*/
#include "rv/rvsc_map.pike";     /* include image processor  */
#include "rv/Alternate.pike";    /* include Alternate airport finder */
#include "rv/codefinder.pike";   /*ICAO CODEFINDER*/

int main(int argc, array(string) argv)
{      

  mapping ini = read_setings("settings.ini");

  if(argc == 2 && argv[1] =="--update") { write("UPDATING...\n"); return 0; }
  
 object server=Protocols.HTTP.Server.Port(handle_request, (int) ini->PORT);
  write("System running...\nopen your webbrowser and go to http://localhost:%s\n to stop the system, close this window.\n",(string) ini->PORT);
  return -1;
}
