<html>
 <head>
  <title>route from %ICAO1% (%NAME1%) to %ICAO2% (%NAME2%)</title>
  <style type="text/css">
   <!--
    body { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
    td   { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
		h1   { font-family: Verdana, arial, helvetica, sans-serif; font-size: 36px; color: #999999;}

   -->
  </style>
 	<script language="javascript"  type="text/javascript">
		function ALT() {  var later = "later";  }
		function NAV() {  var later = "later";  }
		function WPT() {  var later = "later";  }
	</script>
 </head>

 <body bgcolor="#FFFFFF" text="#000000" link="blue" vlink="red" alink="red" leftmargin=5 topmargin=5 marginheight="5" marginwidth="5">
   <div id="overDiv" style="position:absolute; visibility:hidden; z-index:100;"></div>
   <script language="JavaScript" src="overlib.js"></script>


	<center>
	<span style="font-family: Verdana, arial, helvetica, sans-serif; font-size: 36px; color: #999999; ">%ICAO1% (%NAME1%) - %ICAO2% (%NAME2%)</span>
	<br />
  <font face=Verdana size=3 color=#999999>%AC-REG% ( %AC-TYPE% )<br>

	<br><br><br>

<!-- INFORMATIONS ROWS -->

<table border=1 cellpadding="0" cellspacing="0"><tr><td><br>
<table border=0 cellpadding="0" cellspacing="0" width=600>
 <tr>
<!-- END FIRST ROW -->
	<td valign=top width=200 align=center>
		<b>DIRECT DISTANCE:</b><hr width=90%>
    <table><tr><td>%DISTNM%</td><td> nautical miles</td></tr><tr><td>%DISTMI%</td><td> Land miles</td></tr><tr><td>%DISTKM%</td><td> kilometers</td> </tr></table>
	</td>
	<td bgcolor="#999999"><img width="1" src="/b.gif" height="1"></td>
  <td valign=top width=200 align=center>
  	<center><b>EN-ROUTE DISTANCE:</b></center><hr width=90%>
    <table><tr><td>%ENDISTNM%</td><td> nautical miles</td></tr><tr><td>%ERDISTMI%</td><td> Land miles</td></tr><tr><td>%ERDISTKM%</td><td> kilometers</td></tr></table>
	</td>
	<td bgcolor="#999999"><img width="1" src="/b.gif" height="1"></td>
 	<td valign=top width=200 align=center>
 		<b>FLIGHT TIME:</b><hr width=90%>
    <table><tr><td> %ERTIME%  </td></tr></table>
	</td>
 </tr>
<!-- END FIRST ROW -->
<tr><td>&nbsp; </td><td><img width="1" src="/b.gif" height="1"></td> <td>&nbsp; </td><td><img width="1" src="/b.gif" height="1"></td><td>&nbsp; </td></tr>
<!-- ROW 2 airport info -->
	<td valign=top width=200 align=center>
		<b> %ICAO1%</b><hr width=90% >
		<table><tr><td>Latitude:</td><td>%LATDMS1%</td></tr><tr><td>Longitude:</td><td>%LONGDMS1%</td></tr></table>
		
    <table>		%RWYS1% 		</table>
	</td>
	<td bgcolor="#999999"><img width="1" src="/b.gif" height="1"></td>
  <td valign=top width=200 align=center>
	<b>%ICAO2%</b><hr width=90%>
		<table><tr><td>Latitude:</td><td>%LATDMS2%</td></tr><tr><td>Longitude:</td><td>%LONGDMS2%</td></tr></table>
    <table>		%RWYS2% 		</table>
		</td>
	<td bgcolor="#999999"><img width="1" src="/b.gif" height="1"></td>
 	<td valign=top width=200 align=center>
 		<b>Alternates</b><hr width=90%>
    <table>%ALTERNATE%</table>
	</td>
 </tr>
<!-- END ROW 2 -->


	</table><br>
	</td></tr></table>

	<br><br><br>TEST: ( Wind %INI_WS%kt %INI_WD%° )

	<table border=1 cellpadding="2" cellspacing="2">
	<tr><td>#</td><td>IDENT</td><td>DIST</td><td>FL</td><td>TT</td><td>WCA</td><td>VAR</td><td>MT</td><td>TAS</td><td>GS</td><td>int TIME</td></tr>
	%ROUTE%
	<tr><td></td><td></td><td>%ENDISTNM%</td><td></td><td></td><td></td><td></td><td></td><td></td><td>%ERTIME%</td></tr>
	</table>

	<br><img src="/PLAN_%SESSION%_route.jpg.map">
	<br>
<img src="http://developer.berlios.de/bslogo.php?group_id=1305" width="124" height="32" border="0" alt="BerliOS Developer Logo">
<img src="http://fnp.berlios.de/i/pike.gif" width="130" height="40" border="0" alt="Pike">