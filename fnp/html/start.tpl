<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>RVSC STARTPAGE</title>
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
   // -->
  </script>
  <style type="text/css">

  body { font-family: arial, helvetica, sans-serif; font-size: 15px;


</style>
 </head>
<body bgcolor="#FFFFFF" text="#000000" link="blue" vlink="blue" alink="blue" leftmargin=0 topmargin=0 marginheight="0" marginwidth="0">
    <center>


 <font face=Verdana size=10 color=#000000>FNP|RVSC</font>
               <br><br><br><br>
<form action="/RVSC/route">
<table  valign="top" border="0" cellspacing="0" cellpadding="0" height="">
<tr><td><font face=Verdana size=2 color=#000000>FROM &nbsp;</td><td><input type="text" name="from" size="4" maxlength="4"></td></tr>
<tr><td><font face=Verdana size=2 color=#000000>TO</td><td><input type="text" name="to" size="4" maxlength="4"></td></tr>

</table>     <input type="submit" name="go"> </form>

<br><br>
<a href="/CODEFINDER/" onclick="NewWindow(this.href,'','400','450','yes','center');return false" onfocus="this.blur()">AIRPORT CODE FINDER</a>
<br><br><b><font color="red">NOTE: VISUAL MAPPING WORKS ONLY WITH GERMAN AIRPORTS IN THIS RELASE</font></b>
<br><br>

<iframe width="600" height="60" src="http://fnp.berlios.de/version/?version=%VERSION%" frameborder="0" SCROLLING="NO"></iframe>
     
    
</body>
</html>
