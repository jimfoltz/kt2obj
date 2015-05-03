@ECHO OFF
ECHO %~n0 v1.1.0
ECHO.

SET TEMPDIR=%TEMP%\KT2OBJ
SET LOGFILE=%TEMPDIR%\%~n0_%~n1.log

REM Create temporary directory
IF NOT EXIST "%TEMPDIR%" MD "%TEMPDIR%"

IF EXIST "%LOGFILE%" DEL "%LOGFILE%"

SET INFILE=%~1

REM IF ZIP THEN UNZIP
IF /I "%~x1" == ".KZX" (
  CALL :EXTRACT "%INFILE%"
)

REM TRANSFORM KT FILE INTO OBJ + MTL
IF NOT "%INFILE%" == "" (
  CALL :TRANSFORM "%INFILE%" %1

  IF /I "%~x1" == ".KZX" (

    REM the files were output into the temp directory move them into the right directory
    CALL :MOVEFILES "%INFILE%" %1

    REM REMOVE FILE
    IF EXIST "%INFILE%" DEL "%INFILE%"

  )
)

PAUSE

GOTO :EOF

:MOVEFILES
IF "%TRANSFORM%" == "2" (
  ECHO MOVING "%~dpn1.mtl" to "%~dpn2.mtl"
  MOVE /Y "%~dpn1.mtl" "%~dpn2.mtl"
)

IF NOT "%TRANSFORM%" == "" (
  ECHO MOVING "%~dpn1.obj" to "%~dpn2.obj"
  MOVE /Y "%~dpn1.obj" "%~dpn2.obj"
)

GOTO :EOF


:EXTRACT
SET INFILE=

REM EXTRACT THE FILE
"%~dp07-zip\7z" e %1 -o"%TEMPDIR%" -y 1>"%LOGFILE%"

FOR /F "tokens=1-2 delims= " %%i IN ('FINDSTR /B /C:"Extracting  " "%LOGFILE%"') DO (
  SET INFILE=%TEMPDIR%\%%j
)

IF EXIST "%LOGFILE%" DEL "%LOGFILE%"

GOTO :EOF


:TRANSFORM
SET TRANSFORM=

ECHO Converting %1 into "%~dpn1.obj"...

"%~dp0saxon\bin\transform" -s:%1 -o:"%~dpn1.obj.tmp" -xsl:"%~dp0kt2obj.xslt"

IF NOT ERRORLEVEL 1 (
  REM No error
  ECHO>"%~dpn1.obj" mtllib %~n2.mtl
  TYPE "%~dpn1.obj.tmp" >>"%~dpn1.obj"

  ECHO Status: Successfully converted
  ECHO.

  SET TRANSFORM=1
  ECHO Creating "%~dpn1.mtl" from %1...
  
  "%~dp0saxon\bin\transform" -s:%1 -o:"%~dpn1.mtl" -xsl:"%~dp0kt2mtl.xslt"

  IF NOT ERRORLEVEL 1 (
    ECHO Status: MTL Successfully created
    ECHO.
    SET TRANSFORM=2
  )
)

IF EXIST "%~dpn1.obj.tmp" DEL "%~dpn1.obj.tmp"

GOTO :EOF