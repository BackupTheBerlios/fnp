@echo off
REM ###################################################
REM ## Great Circle Distance and Course Calculator   ##
REM ## Copyright (C) 2002,2003,2004 by Blutorgel.net ##
REM ## Pike: http://pike.ida.liu.se/                 ##
REM ###################################################


TITLE Great Circle Distance and Course  Calculator

IF EXIST c:\rvsc\pike\pike\7.4.31\bin\pike.exe  (
    c:\rvsc\pike\pike\7.4.31\bin\pike.exe c:\rvsc\server.pike
  PAUSE

 ) ELSE (
   echo  ERROR! MAKE SHURE THAT THE INSTALL FILES ARE IN c:\rvsc
   PAUSE
 )




