@echo off
::if not "%1" == "max" start /MAX cmd /c %0 max & exit/b
cd C:\tools\jj

:loop
cls
Title "__search youtube__ "
set "query="
SET /P query=search:
if "%query%" == "" exit
if "%query%" == "ch" goto channel
if "%query%" == "config" start /max notepad++ jj.bat ytapi_search.py
if "%query%" == "config" goto loop

::search 

::---->using youtube data v3 api
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytapi_search "%query%"

::---->using inbuilt seatch function of youtube-dl
::youtube-dl -s --get-title --get-id --get-duration "ytsearch7:%query%" >ytslist.txt 
::IF ERRORLEVEL 1 GOTO loop
::sed -n 'p;n;n' ytslist.txt > ytstitle.txt
::sed -n 'n;n;p' ytslist.txt > ytstime.txt
::sed -n 'n;p;n' ytslist.txt > ytsid.txt
:::paste ytstitle.txt ytsid.txt > ytsresult.txt

:option
cls
Title "youtube "%query%
echo:
cat ytsresult.txt |nl

echo:
set "choice="
set /P choice=">":
if "%choice%" == "" goto option
if "%choice%" == "ch" goto channel

for /f %%v in ('echo %choice% ^| tr -d -c 0-9') do (set "id=%%v")
for /f %%v in ('sed "%id%q;d" ytsid.txt') do (set "ytid=%%v")

if not x%choice:q=%==x%choice% exit
if not x%choice:m=%==x%choice% goto dmp3
if not x%choice:a=%==x%choice% goto audio
if not x%choice:l=%==x%choice% goto v240
if not x%choice:v=%==x%choice% goto v480
if not x%choice:d=%==x%choice% goto resolution
if not x%choice:ss=%==x%choice% goto loop

if %choice% GEQ 1 if %choice% LEQ 44 goto video


:audio
mpv --volume=70 --ytdl-format=bestaudio https://www.youtube.com/watch?v=%ytid%
goto option

:v240
mpv --no-terminal --video-aspect-override=16:9 --volume=70 --fs --ytdl-format=133+worstaudio https://www.youtube.com/watch?v=%ytid%
goto option

:video
mpv --no-terminal --video-aspect-override=16:9 --volume=70 --fs --ytdl-format=134+worstaudio https://www.youtube.com/watch?v=%ytid%
goto option

:v480
mpv --no-terminal --video-aspect-override=16:9 --volume=70 --fs --ytdl-format=135+worstaudio https://www.youtube.com/watch?v=%ytid%
goto option


:Download
set /P res=(q or res):
if not x%res:q=%==x%res% goto option

if %res% equ 134 goto d360p
if %res% equ 135 goto d480p
if %res% equ 136 goto d720p

:dmp3
start /min youtube-dl -x -o d/m/%%(title)s.%%(ext)s -- %ytid%
goto option

:d360p
start /min youtube-dl -i -o d/%%(title)s.%%(ext)s -f 134+249 -- %ytid% ^|^| youtube-dl -o d/%%(title)s.%%(ext)s -f 134+139 -- %ytid%
goto option

:d480p
start /min youtube-dl -i -o d/%%(title)s.%%(ext)s -f 135+249 -- %ytid% ^|^| youtube-dl -o d/%%(title)s.%%(ext)s -f 135+139 -- %ytid%
goto option

:d720p
start /min youtube-dl -i -o d/%%(title)s.%%(ext)s -f 136+249 -- %ytid% ^|^| youtube-dl -o d/%%(title)s.%%(ext)s -f 136+139 -- %ytid%
goto option


:resolution
youtube-dl -F %ytid% > reslist.txt
grep '134' reslist.txt
grep '135' reslist.txt
grep '136' reslist.txt
goto Download







::channel rss implementation
:channel
cls
Title "youtube_channels"
set "query="
SET /P query=channel:
if "%query%" == "" exit
if "%query%" == "krk" goto krk
if "%query%" == "tw" goto thewire
if "%query%" == "nl" goto newslaundry
if "%query%" == "ary" goto arydigital
if "%query%" == "htv" goto humtv

::search 

::---->using youtube data v3 api

:thewire
wget -qO- https://www.youtube.com/feeds/videos.xml?channel_id=UChWtJey46brNr7qHQpN6KLQ >feed.xml
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytrss.py 
cat ytrsst.txt |nl
goto option


:newslaundry
wget -qO- https://www.youtube.com/feeds/videos.xml?user=newslaundry >feed.xml
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytrss.py 
cat ytrsst.txt |nl
goto option


:arydigital
wget -qO- https://www.youtube.com/feeds/videos.xml?channel_id=UC4JCksJF76g_MdzPVBJoC3Q >feed.xml
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytrss.py 
cat ytrsst.txt |nl
goto option

:humtv
wget -qO- https://www.youtube.com/feeds/videos.xml?user=HumNetwork >feed.xml
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytrss.py 
cat ytrsst.txt |nl
goto option


:krk
wget -qO- https://www.youtube.com/feeds/videos.xml?user=krklive >feed.xml
call C:\Users\runner\pyenvironment\youtube_viewer\Scripts\activate 
ytrss.py 
cat ytrsst.txt |nl
goto option




