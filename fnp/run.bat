@echo off
REM ###################################################
REM ## FNP | RVSP FLIGHT NAVIGATION PLANER           ##
REM ## (C) 2002,2003,2004 by http://fnp.berlios.de   ##
REM ## This Software is released under the GNU       ##
REM ## General Public License (GPL).                 ##
REM ###################################################


TITLE FNP : RVSP FLIGHT NAVIGATION PLANER

IF EXIST c:\rvsc\pike\7.4.31\bin\pike.exe  (
    c:\rvsc\pike\7.4.31\bin\pike.exe c:\rvsc\server.pike
  
 ) ELSE (
   echo  ERROR! MAKE SHURE THAT THE INSTALL FILES ARE IN c:\rvsc
   PAUSE
 )




