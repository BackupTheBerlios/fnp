 <html>
 <script language="javascript"  type="text/javascript">


		function Show(key)
		{
		if(key =="fl") {	document.getElementById("fl").style.display='inline'; }
		if(key =="tas") {	document.getElementById("tas").style.display='inline'; }
		if(key =="add_man") {	document.getElementById("add_man").style.display='inline'; }



		}
		function sendfl()
		{
			if(document.fl.val.value >1 && document.fl.val.value <9999)
				{	opener.location.href= '/KLICK_%session%.fnp?update=fl&hop=%hop%&value='+document.fl.val.value;}
			else
				{ alert(document.fl.val.value+"is not valid");}
			self.close();
			}

			function sendtas()
			{
			if(document.tas.val.value >1 && document.tas.val.value <9999)
				{ opener.location.href= '/KLICK_%session%.fnp?update=tas&hop=%hop%&value='+document.tas.val.value; self.close(); }
			else
				{ alert(document.tas.val.value+"is not valid");}
			self.close();
			}

	 </script>
  <style type="text/css">
 <!--
 A { text-decoration:none;  }
  body { font-family: arial, helvetica, sans-serif; font-size: 15px;}
	.ICAOField { background-color: #ececec; border: 1px solid;}; font-family: verdana; font-size: 12pt; color: #000000; font-weight: bold;}
	.ACDropDown { background-color: #ececec; font-family: verdana; font-size: 12pt; color: #000000; font-weight: bold;}
	.TDFieldDesc { text-decoration:none; background-color: #ececec; font-family: verdana; font-size: 12pt; color: #000000; }
.SectionHeader	{ font-family: arial, helvetica, sans-serif; font-size: 15px; font-weight: bold;}
-->
</style>
<body onLoad="Show('%tpl%')"; bgcolor="#ececec" text="#000000" link="blue" vlink="blue" alink="blue" leftmargin=0 topmargin=0 marginheight="0" marginwidth="0">
<span id="tas" style="display:none">

<form name="tas">
<table  valign="center" border="0" cellspacing="1" cellpadding="0" height="">
	<tr>
		<td class="TDFieldDesc">TAS:</td>
		<td><input class="ICAOField" type="text" value ="" name="val" size="4" maxlength="4"></td>
	</tr>
</table>
<input type="submit" name="go" value="Save" onclick="sendtas();" class="ICAOField" >
</form>
</span>


<div id="fl" style="display:none">
<form name="fl">
<table  valign="center" border="0" cellspacing="1" cellpadding="0" height="">
	<tr>
		<td class="TDFieldDesc">FLIGHTLEVEL:</td>
		<td><input class="ICAOField" type="text" value ="" name="val" size="4" maxlength="4"></td>
	</tr>

</table>
<input type="submit" name="go" value="Save" onclick="sendfl();" class="ICAOField"> </form>

</div>


<div id="add_man" style="display:none">
MANUAL_ADD
%tpl%  %type%  %wpt%
</div>
