<html>
 <head>
  <title>route from %ICAO1% (%NAME1%) to %ICAO2% (%NAME2%)</title>
  <style type="text/css">
   <!--
    body { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
    td   { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
   -->
  </style>
 </head>
 <body bgcolor="#FFFFFF" text="#000000" link="blue" vlink="red" alink="red" leftmargin=5 topmargin=5 marginheight="5" marginwidth="5">

 <br>
  <center><font face=Verdana size=4 color=#999999><u>%ICAO1% (%NAME1%) - %ICAO2% (%NAME2%)</u></font><br>
  <br>

 <table border=0 cellpadding="0" cellspacing="0">
  <tr>
   <td valign=top>

     %DATE% %TIME%
    <hr><b>DISTANCE:</b><br>
    <table>
     <tr><td>nautical miles</td><td>%DIST_NM%</td></tr>
     <tr><td>Land miles</td><td> %DIST_MI%</td></tr>
     <tr><td>kilometers</td><td>%DIST_KM%</td> </tr>
    </table>

    <hr><b>FLIGHDATA:</b><br>
    <table>
     <tr><td>%HEADING%</td><td> True Course</td></tr>
     <tr><td>%GS%</td><td> Ground  Speed</td></tr>
     <tr><td>%FLIGHTTIME%</td><td>Min. Flight Time</td></tr>
    </table>

    <hr><b>AIRPORTS INFORMATIONS:</b><br>
    <table>
     <tr><td>%ICAO1%</td><td>%NAME1%</td></tr>
     <tr><td>Max Runway </td><td>%RWY1% ft.</td></tr>
     <tr><td>Lat</td><td>%LAT1%</td></tr>
     <tr><td>Long</td><td> %LONG1%</td></tr>
    </table>

    <table>
     <tr><td>%ICAO2%</td><td>%NAME2%</td></tr>
     <tr><td>Max Runway </td><td>%RWY2% ft.</td></tr>
     <tr><td>Lat</td><td>%LAT2%</td></tr>
     <tr><td>Long</td><td> %LONG2%</td></tr>
    </table>

    <hr><b>ALTERNATE AIRPORTS</b>
    <table>
     <tr><td>ICAO</td><td>&nbsp;</td><td>distance</td></tr>
     {ALTERNATE}
    </table>
   </td>
   <td valign=top>&nbsp;&nbsp;&nbsp;</td>
   <td valign=top>
    <img src="/RVSC_MAP/?from=%ICAO1%&to=%ICAO2%" border=1>
   </td>
  </tr>
 </table>
 <hr>
  <center><font face=Verdana size=4 color=#999999><u>WIND & GROUNDSPEED</u></font><br> <br>
 <table border=0 cellpadding="3" cellspacing="3">
  <tr>
   <td>true course (TC)</td>
   <td>%HEADING% °</td>
   <td>&nbsp;&nbsp;&nbsp;</td>
   <td>true airspeed (TAS)</td>
   <td>%INI_TAS% kt.</td>
  </tr>
  <tr>
   <td>wind direction (WD)</td>
   <td>%INI_WD% °</td>
   <td></td>
   <td>wind correction angle (WCA)</td>
   <td>%WCA% °</td>
  </tr>
  <tr>
   <td>wind speed (WS)</td>
   <td>%INI_WS% kt.</td>
   <td></td>
   <td>Ground Speed (GS)</td>
   <td>%GS% kt.</td>
  </tr>
  <tr>
   <td>Mach number (M)</td>
   <td></td>
   <td></td>
   <td>Drift</td>
   <td></td>
  </tr>
 </table>
<br> <font color="RED">NOTE:</font> WD,WS,TAS fixed set in "settings.ini"<br>


