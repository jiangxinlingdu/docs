:GetTempName
set tmpfile=%TMP%.\JadTidied-%RANDOM%-%TIME:~6,5%.tmp
if exist "%tmpfile%" goto :GetTempName
Helpers\Java\jad.exe -p %1 > "%tmpfile%"
for %%F in (%tmpfile%) do set size=%%~zF
if /I %size%  equ 0 goto :SkipJalopy
type "%tmpfile%" | java -classpath Helpers\Java\jalopy\lib\getopt.jar;Helpers\Java\jalopy\lib\jalopy.jar;Helpers\Java\jalopy\lib\jalopy-console.jar;Helpers\Java\jalopy\lib\log4j.jar de.hunsicker.jalopy.plugin.console.ConsolePlugin > %2
:SkipJalopy
del "%tmpfile%"