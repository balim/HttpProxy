@echo off

if "%OS%"=="Windows_NT" @setlocal

rem %~dp0 is expanded pathname of the current script under NT
set DEFAULT_DM_HOME=%~dp0..

if "%DM_HOME%"=="" set DM_HOME=%DEFAULT_DM_HOME%
set DEFAULT_DM_HOME=


rem find DM_HOME if it does not exist due to either an invalid value passed
rem by the user or the %0 problem on Windows 9x
if exist "%DM_HOME%" goto checkJava

rem check for dm dir in Program Files on system drive
if not exist "%SystemDrive%\Program Files\dm" goto checkSystemDrive
set DM_HOME=%SystemDrive%\Program Files\dm
goto checkJava

:checkSystemDrive
rem check for dm in root directory of system drive
if not exist %SystemDrive%\dm\nul goto checkCDrive
set DM_HOME=%SystemDrive%\dm
goto checkJava

:checkCDrive
rem check for dm in C:\dm for Win9X users
if not exist C:\dm\nul goto noDMHome
set DM_HOME=C:\dm
goto checkJava

:noDMHome
echo DM_HOME is set incorrectly or dm could not be located. Please set DM_HOME.
goto end

:checkJava
set LOCALCLASSPATH=%CLASSPATH%
for %%i in ("%DM_HOME%\lib\*.jar") do call "%DM_HOME%\bin\lcp.cmd" %%i

if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\javaw.exe" goto noJavaHome
set _JAVACMD=%JAVA_HOME%\bin\javaw.exe
goto checkJikes

:noJavaHome
set _JAVACMD=javaw.exe
echo.
echo Warning: JAVA_HOME environment variable is not set.
echo   If build fails because sun.* classes could not be found
echo   you will need to set the JAVA_HOME environment variable
echo   to the installation directory of java.
echo.

:checkJikes
if not "%JIKESPATH%"=="" goto runDMWithJikes

:runDM
start "" "%_JAVACMD%" -classpath "%LOCALCLASSPATH%" "-Ddm.home=%DM_HOME%" HttpProxyUI %*
goto end

:runDMWithJikes
start "" "%_JAVACMD%" -classpath "%LOCALCLASSPATH%" "-Ddm.home=%DM_HOME%" "-Djikes.class.path=%JIKESPATH%" %DM_OPTS% HttpProxyUI %*
goto end

:end
set LOCALCLASSPATH=
set _JAVACMD=
set DM_CMD_LINE_ARGS=

if "%OS%"=="Windows_NT" @endlocal

:mainEnd


