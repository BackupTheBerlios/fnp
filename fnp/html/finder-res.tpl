<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>RVSC CODEFINDER</title>
<script language="javascript"  type="text/javascript">
   <!--
       function from( icao ) { self.opener.document.forms[0].from.value = icao; self.close(); }
       function to( icao )   { self.opener.document.forms[0].to.value = icao;   self.close(); }
   // -->
</script>
</head>
<body>
<font face=Verdana size=1 color=#000000><a href="/CODEFINDER/">[BACK]</a> ||<a href=# onclick="self.close(); return false">close window</a><br>
<table valign="top" border="0" cellspacing="0" cellpadding="0" height="">
{LIST}
<tr><td><font face=Verdana size=1 color=#000000>%icao%&nbsp;</td>
<td><font face=Verdana size=1 color=#000000>|&nbsp;%airport% &nbsp;  &nbsp; </td>
<td><font face=Verdana size=1 color=#000000> <a href=# onclick="from('%icao%'); return false">from</a> |  <a href=# onclick="to('%icao%'); return false">to</a></tr>
{LIST}
</table>
</body>
</html>
