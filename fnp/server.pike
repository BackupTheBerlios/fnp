#include "rv/main.pike";         /* include main system*/
#include "rv/Geo.pike";          /* include geo stuff */
#include "rv/txtproc.pike";      /* include textprocess tools*/
#include "rv/rvsc_map.pike";     /* include image processor  */
#include "rv/Alternate.pike";    /* include Alternate airport finder */
#include "rv/codefinder.pike";   /*ICAO CODEFINDER*/

int main()
{
  mapping ini = read_setings("settings.ini");
  object server=Protocols.HTTP.Server.Port(handle_request, (int) ini->PORT);
  write("System running...\nopen your webbrowser and go to http://localhost:%s\n to stop the system, close this window.",(string) ini->PORT);
  return -1;
}


