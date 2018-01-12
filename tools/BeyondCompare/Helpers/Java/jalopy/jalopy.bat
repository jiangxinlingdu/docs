@ECHO OFF
IF NOT "%OS%"=="Windows_NT" GOTO win9xStart

:winNTStart
@setlocal

REM Need to check if we are using the 4NT shell...
IF "%eval[2+2]" == "4" GOTO setup4NT

REM On NT/2K grab all arguments at once
SET JALOPY_CMD_LINE_ARGS=%*
GOTO doneStart

:setup4NT
SET JALOPYY_CMD_LINE_ARGS=%$
GOTO doneStart

:win9xStart
REM Slurp the command line arguments. This loop allows for an unlimited number
REM of arguments (up to the command line limit, anyway).
SET JALOPY_CMD_LINE_ARGS=

:setupArgs
IF %1a==a GOTO doneStart
SET JALOPY_CMD_LINE_ARGS=%JALOPY_CMD_LINE_ARGS% %1
SHIFT
GOTO setupArgs

:doneStart
REM This label provides a place for the argument list loop to break out
REM and for NT handling to skip to.

:checkJava
SET _JAVACMD=%JAVACMD%
SET LOCALCLASSPATH=
FOR %%i IN (".\lib\*.jar") do call ".\lcp.bat" %%i

IF "%JAVA_HOME%" == "" GOTO noJavaHome
IF "%_JAVACMD%" == "" SET _JAVACMD=%JAVA_HOME%\bin\java
GOTO runJalopy

:noJavaHome
IF "%_JAVACMD%" == "" SET _JAVACMD=java
ECHO.
ECHO Warning: JAVA_HOME environment variable is not set.
ECHO   You may need to set the JAVA_HOME environment variable
ECHO   to the installation directory of Java.
ECHO.

:runJalopy
"%_JAVACMD%" -classpath "%LOCALCLASSPATH%" de.hunsicker.jalopy.plugin.console.ConsolePlugin %JALOPY_CMD_LINE_ARGS%
GOTO end

:end
SET LOCALCLASSPATH=
SET _JAVACMD=
SET JALOPY_CMD_LINE_ARGS=

IF NOT "%OS%"=="Windows_NT" GOTO mainEnd
:winNTend
@endlocal

:mainEnd
