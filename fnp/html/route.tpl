<html>
 <head>
  <title>route from %ICAO1% (%NAME1%) to %ICAO2% (%NAME2%)</title>
  <style type="text/css">
   <!--
    body { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
    td   { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
   -->
  </style>
 	<script language="javascript"  type="text/javascript">
		function ALT() {  var later = "later";  }
		function NAV() {  var later = "later";  }
		function WPT() {  var later = "later";  }
	</script>
 </head>

 <body bgcolor="#FFFFFF" text="#000000" link="blue" vlink="red" alink="red" leftmargin=5 topmargin=5 marginheight="5" marginwidth="5">
 <table border=0 cellpadding="0" cellspacing="0" width=100%>
 <tr><td valign=top><br><br>
  <a href="/">NEW</a><br><br>
  <a href="http://fnp.berlios.de/">FNP HOME</a><br><br>
  <a href="http://fnp.berlios.de/forum/list.php?f=1">FNP FORUM</a><br><br>
  <a href="http://developer.berlios.de/docman/?group_id=1305">Documentation</a><br><br>
 </td>
 <td bgcolor=#999999>&nbsp;</td>
 <td >


  <center><font face=Verdana size=4 color=#999999><u>%ICAO1% (%NAME1%) - %ICAO2% (%NAME2%)</u></font><br />
   <font face=Verdana size=3 color=#999999>%AC-REG% / %AC-TYPE% <br>
  
  <br>
   <div id="overDiv" style="position:absolute; visibility:hidden; z-index:100;"></div>
   <script language="JavaScript" src="overlib.js"></script>


 <table border=0 cellpadding="0" cellspacing="0">
  <tr>
   <td valign=top>

     Date/Time: %DATE% %TIME%
    <hr><b>DISTANCE:</b><br>
    <table>
     <tr><td>nautical miles</td><td>%DISTNM%</td></tr>
     <tr><td>Land miles</td><td> %DISTMI%</td></tr>
     <tr><td>kilometers</td><td>%DISTKM%</td> </tr>
    </table>

    <hr><b>FLIGHTDATA:</b><br>
    <table>
     <tr><td>True Course</td><td> %HEADING%</td></tr>
     <tr><td>Ground  Speed</td><td>%GS% NM</td></tr>
     <tr><td>True Air Speed</td><td> %AC-TAS% NM</td></tr>

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
     <tr><td>ICAO</td><td>Name</td><td>distance</td></tr>
     %ALTERNATE%
    </table>
   </td>
   <td valign=top>&nbsp;&nbsp;&nbsp;</td>
   <td valign=top>
    <map name="maphits">
    %IMGMAP%
    </map>

    <img src="/PLAN_%SESSION%_route.jpg" width="330" height="448" border="1" alt="Karte" usemap="#maphits">
	<br><font face=Verdana size=3 color=#000000>
	move the mouse over the map!

   </td>
  </tr>
 </table>
 <hr>
  <center><font face=Verdana size=4 color=#999999><u>ENROUTE WIND & GROUNDSPEED</u></font><br> <br>
 <table border=0 cellpadding="3" cellspacing="3">
  <tr>
   <td>true course (TC)</td>
   <td>%HEADING% °</td>
   <td>&nbsp;&nbsp;&nbsp;</td>
   <td>true airspeed (TAS)</td>
   <td>%AC-TAS% kt.</td>
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
 
<br><font color="RED">NOTE:</font> WD,WS,TAS fixed set in "settings.ini"
<br>  <hr><br>
<center><font face=Verdana size=4 color=#999999><u>WEATHERSTATIONS:</u></font><br> <br>
<!-- table border=1 cellpadding="0" cellspacing="0">
  <tr>
   <td><iframe width="600" height="80" src="http://weather.noaa.gov/pub/data/forecasts/taf/stations/%ICAO1%.TXT" frameborder="0" SCROLLING="YES"></iframe></td>
  </tr>
  <tr>
   <td><iframe width="600" height="80" src="http://weather.noaa.gov/pub/data/forecasts/taf/stations/%ICAO2%.TXT" frameborder="0" SCROLLING="YES"></iframe></td>
  </tr>
</table -->

</td><td bgcolor=#999999>&nbsp;</td>
</tr>
</table>

  

