<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>START: FLIGHT NAVIGATION PLANER</title>
  <script language="javascript"  type="text/javascript">
   <!--
     var win=null;
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


		function SendACData(reg)

		{

		{AC-JS}

		}
		function ShowOptions()
		{

		if(document.getElementById('MoreOptions').style.display =='none')
			{
				document.getElementById('MoreOptions').style.display='inline';
				document.SendToR.MoreOptions.value = "Less Options";
			}
			else
			{
			document.getElementById('MoreOptions').style.display='none';
			document.SendToR.MoreOptions.value = "More Options";
			}



		}
	 // -->

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
 </head>
<body onLoad="SendACData('%FIRST-AC-IN-LIST%')"; bgcolor="#FFFFFF" text="#000000" link="blue" vlink="blue" alink="blue" leftmargin=0 topmargin=0 marginheight="0" marginwidth="0">
 <div id="overDiv" style="position:absolute; visibility:hidden; z-index:100;"></div>
   <script language="JavaScript" src="overlib.js"></script>
   <center>


 <font face=Verdana size=10 color=#000000>FNP</font>
               <br><br><br><br>
<form action="/R/" name="SendToR">
<table  valign="top" border="0" cellspacing="1" cellpadding="0" height="">
	<tr>
		<td class="TDFieldDesc">FROM (ICAO code)&nbsp;</td>
		<td><input class="ICAOField" type="text" value ="EDTF%PRE_FROM%" name="from" size="4" maxlength="4"></td>
	</tr>
	<tr>
		<td class="TDFieldDesc">TO (ICAO code)</td>
		<td><input class="ICAOField"  type="text" name="to" value ="ETNL%PRE_TO%" size="4" maxlength="4"></td>
	</tr>
	<tr>
		<td class="TDFieldDesc">Aircraft</td>
		<td><select class="ICAOField"  name="ac" onChange="SendACData(document.SendToR.ac.value)">{AC-LIST}</select></td>
	</tr>
</table>

<span id="MoreOptions" style="display:inline;">
<br>
<div class="SectionHeader">Aircraft Data</div>
<table border =0  cellspacing="0" cellpadding="1">
 <tr>
  <td>
	 <table  valign="top" border="0" cellspacing="1" cellpadding="1" height="">
 		<tr>
			<td class="TDFieldDesc">IDENTIFICATION</td><td><input class="ICAOField" type="text" name="AC_REG" value ="" size="10"></td>
			<td class="TDFieldDesc">TYPE</td><td><input class="ICAOField" type="text" name="AC_TYPE" value ="" size="24"></td>
			<td class="TDFieldDesc">/</td><td><input class="ICAOField" type="text" name="AC_TYPEFP" value ="" size="4"></td>
			<td class="TDFieldDesc">REMARKS</td><td><input class="ICAOField" type="text" name="AC_RMK" value ="" size="26"></td>
 		</tr>
	 </table>
	</td>
 </tr>
  <tr>
  <td>
	 <table  valign="top" border="0" cellspacing="0" cellpadding="0" height="">
		<tr>
		 <td   valign="top" >
			<table  valign="top" border="0" cellspacing="0" cellpadding="0" height="">
 				<tr><td class="TDFieldDesc">MAX TAS</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_TAS" value =""  maxlength="4" size="10"> KT</td></tr>
			  <tr><td class="TDFieldDesc">MAX FL</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_FL" value =""  maxlength="3" size="10"></td></tr>
  			<tr><td class="TDFieldDesc">MOTW</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_MOTW" value =""  maxlength="6" size="10"> KG</td></tr>
				<tr><td class="TDFieldDesc">MIN RWY</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_RWY" value =""  maxlength="5" size="10"> FT</td></tr>
				<tr><td class="TDFieldDesc">MAX RANGE&nbsp;</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_RANGE" value =""  maxlength="5" size="10"> NM</td></tr>
				<td class="TDFieldDesc"><a onmouseover="return overlib('Endurance: Fuel on board in time');"onmouseout='return nd();' href="javascript:void()">ENDURANCE</a>&nbsp;</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_END" value ="" size="10"> H:M</td>
			</table>
		 </td><td bgcolor=""><img width="3" src="/b.gif" height="1"></td>
 		 <td  valign="top" >
			<table  valign="top" border="0" cellspacing="0" cellpadding="0" height="">
			 <tr><td class="TDFieldDesc">COLOR&nbsp;</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_COLOR" value ="" size="16"></td></tr>
			 <tr><td class="TDFieldDesc"><a onmouseover="return overlib('Wake Turbulence Category');"onmouseout='return nd();' href="javascript:void()">WAKE TURB.&nbsp;</a> </td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_WTC" value =""  maxlength="1" size="16"></td></tr>
			 <tr><td class="TDFieldDesc"><a onmouseover="return overlib(' Persons on board');"onmouseout='return nd();' href="javascript:void()">PERSONS</a></td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_POB" value =""  maxlength="3" size="16"></td></tr>
			 <tr><td class="TDFieldDesc">COM/NAV</td><td><input class="ICAOField" type="text" name="AC_EQU" value ="" size="16"></td></tr>
			 <tr><td class="TDFieldDesc">TRANSPONDER&nbsp;</td><td><input class="ICAOField" type="text" name="AC_TPR" value ="" size="16"></td></tr>
			 <tr><td class="TDFieldDesc"><a onmouseover="return overlib('Emergency Radio equipment');"onmouseout='return nd();' href="javascript:void()">EMG RADIO</a>&nbsp;</td><td><input class="ICAOField" type="text" name="AC_ERE" value ="" size="16"></td></tr>
      </table>
		 </td><td ><img width="3" src="/b.gif" height="1"></td>
	   <td  valign="top" >
			<table  valign="top" border="0" cellspacing="0" cellpadding="0" height="">
  			<tr><td class="TDFieldDesc"><a onmouseover="return overlib('Survival Equipment (Maritime, Jungle...Life Jackets with Lights, Fluorescene Die...)');"onmouseout='return nd();' href="javascript:void()">SURVIAL</a></td>
			 			<td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_SUR" value =""   size="16"></td></tr>
				<tr><td class="TDFieldDesc"><a onmouseover="return overlib('Number Dinghies');"onmouseout='return nd();' href="javascript:void()">DINGHIES</a></td>
			 			<td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_DIN" value =""   size="16"></td></tr>
				<tr><td class="TDFieldDesc"><a onmouseover="return overlib('Dinghies Covered');"onmouseout='return nd();' href="javascript:void()">DIN. COVERED</a>&nbsp;</td>
			 			<td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_DIN_COVERED" value =""   size="16"></td></tr>
				<tr><td class="TDFieldDesc"><a onmouseover="return overlib('Dinghies Capacity');"onmouseout='return nd();' href="javascript:void()">DIN. CAPACITY</a></td>
			 			<td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_DIN_CAP" value =""   size="16"></td></tr>
				<tr><td class="TDFieldDesc"><a onmouseover="return overlib('Dinghies Color');"onmouseout='return nd();' href="javascript:void()">DIN. COLOR</a></td>
			 			<td class="TDFieldDesc"><input class="ICAOField" type="text" name="AC_DIN_COLOR" value =""   size="16"></td></tr>
			</table>
		 </td>
    </tr>
   </table>
  </td>
 </tr>
</table>

<br><div class="SectionHeader">Weather Data (en-route)</div>
<table border =0  cellspacing="0" cellpadding="1">
 <tr>
  <td>
	 <table  valign="top" border="0" cellspacing="1" cellpadding="1" height="">
 		<tr>
			<td class="TDFieldDesc">WINDSPEED&nbsp;</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="WEATHER_WS" value ="%WS%" size="3"> kt</td>
			<td ><img width="3" src="/b.gif" height="1"></td>
			<td class="TDFieldDesc">WIND DIRECTION&nbsp;</td><td class="TDFieldDesc"><input class="ICAOField" type="text" name="WEATHER_WD" value ="%WD%" size="3"> °</td>
 		</tr>
	 </table>
	</td>
 </tr>
</table>
</span>



<br>

<input type="submit" class="ICAOField" onclick="NewWindow(this.href,'','400','450','yes','center');return false" onfocus="this.blur()" value="AIRPORT CODE FINDER" />
<input  class="ICAOField" type="submit" onclick="ShowOptions(); return false" name="MoreOptions" value="More Options">
<input type="submit" name="go" value="Start Router" class="ICAOField"> </form>


<br><br><b><font color="red">NOTE: THIS VERSION - ONLY GERMAN DATABASE  <br></font></b>
<br><br>

<iframe width="600" height="60" src="http://fnp.berlios.de/version/?version=%VERSION%" frameborder="0" SCROLLING="NO"></iframe>


</body>
</html>
