<html>
 <head>
  <title>route from %ICAO1% (%NAME1%) to %ICAO2% (%NAME2%)</title>
  <style type="text/css">
   <!--
	 A { text-decoration:none;  }
    body { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
    td   { font-family: Verdana, arial, helvetica, sans-serif; font-size: 12px; }
			.ICAOField { background-color: #ececec; border: 1px solid;}; font-family: verdana; font-size: 12pt; color: #000000; font-weight: bold;}
   -->
  </style>
 	<script language="javascript"  type="text/javascript">
 		var win=null;
		self.name = 'klick';

       function NewWindow(mypage,myname,w,h,scroll,pos)
       {
        if(pos=="random")
        {
        LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;
        TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;
        }
        if(pos=="center")
        {
        LeftPosition=(screen.width)?(screen.width-w)/2:100;
        TopPosition=(screen.height)?(screen.height-h)/2:100;
        }
        else if((pos!="center" && pos!="random") || pos==null)
        {
        LeftPosition=0;TopPosition=20
        }
        settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=no';
        win=window.open(mypage,myname,settings);
       }

			function TAS(id)  {	NewWindow("/POPUP_%SESSION%?tpl=tas&hop="+id,'','220','120','yes','center');	}
			function FL(id) 	{	NewWindow("/POPUP_%SESSION%?tpl=fl&hop="+id,'','220','120','yes','center');	}

			function FLOver(id) 	{  overlib('Click to Change Flightlevel'); }
			function TASOver(id) 	{  overlib('Click to Change TAS'); }
			function DELOver(id) 	{  overlib('Click to Delete Waypoint'); }

		function ALT(loc) {
		 document.send_map.dest.value = loc;
		 document.send_map.type.value = "alt";
		 document.send_map.submit();
		 }
		function NAV(loc) {
		 document.send_map.dest.value = loc;
		 document.send_map.type.value = "nav";
		 document.send_map.submit();
		 }
		function WPT(loc) {
		 document.send_map.dest.value = loc;
		 document.send_map.type.value = "wpt";
		 document.send_map.submit();
		 }
		function DEL(loc) {
		 document.send_map.dest.value = loc;
		 document.send_map.type.value = "del";
		 document.send_map.submit();
		 }

		 function READY() {
		 document.ready.submit();
		 }

	</script>



 </head>



<form name="ready" method="GET" action="/PLAN_%SESSION%.fnp">
</form>

<form name="send_map" method="POST" action="/KLICK_%SESSION%.fnp">
	<input type="hidden" name="dest" value=""/>
  <input type="hidden" name="type" value=""/>

</form>


 <body bgcolor="#FFFFFF" text="#000000" link="blue" vlink="red" alink="red" leftmargin=5 topmargin=5 marginheight="5" marginwidth="5">

 <div id="overDiv" style="position:absolute; visibility:hidden; z-index:100;"></div>
   <script language="JavaScript" src="overlib.js"></script>

<br><center><font size=12>RouteKlicker v1</font>
<br><br>

 <table border=0 cellpadding="0" cellspacing="0" width=100%>
 <tr>
 	<td valign=top>


<br><br>
	<table border=1 cellpadding="0" cellspacing="0" width=530>
		<tr>
			<td width=10>#</td><td width=50>Type</td><td width=50> IDENT</td><td width=100>NAME</td><td width=200>DESC</td>
			<td width=50">dist (nm)</td><td width=20">FL</td><td width=20">TAS</td>
			<td width=40">action</td>
		</tr>
		%ROUTE-MAPIING%
	</table>
<table border=0 cellpadding="0" cellspacing="0" width=530 height=100>
 <tr>
  <td align="right" valign="bottom">

	<input  class="ICAOField" type="submit" onclick="READY('1'); return false" name="" value="Next -->">


	</td>
 </tr>
</table>
	</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
 	<td><font size=4>Click your waypoints on the map </font><br/>
			<map name="maphits">%IMGMAP%</map>
    	<img src="/KLICK_%SESSION%_route.jpg" width="330" height="448" border="1" alt="Karte" usemap="#maphits" />
	</td>
 </table>


