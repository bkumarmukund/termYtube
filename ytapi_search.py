import apiclient
from apiclient.discovery import build
from apiclient.errors import HttpError

#input to the file
import sys
import os
query = sys.argv


#os.system('notify-send ' +query)
DEVELOPER_KEY            = "AIzaSyB-Og15ck9oUiAbGUyq169UmO8fwpm-XMg"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION      = "v3"
YOUTUBE_VIDEO_URL_PREFIX = "https://www.youtube.com/watch?v="

youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
                developerKey=DEVELOPER_KEY)

search_response = youtube.search().list(q=query, part="id,snippet",
    maxResults=20).execute()

with open('ytstitle.txt','w',encoding="utf-8") as titlelist, open('ytsid.txt','w') as idlist:
    for result in search_response.get("items",[]):

        if result["id"]["kind"] == "youtube#video":

            ytitle = result["snippet"]["title"]
            titlelist.write(ytitle+'\n')
            yid = result["id"]["videoId"]
            idlist.write(yid+'\n')



#for duration of videos
import isodate
from pathlib import Path
txt = Path('ytsid.txt').read_text().replace('\n',",")

search_response = youtube.videos().list(id=txt, part="contentDetails").execute()


with open('ytstime.txt','w') as tlist:
    i=1
    for result in search_response.get("items",[]):

            ytime = str(isodate.parse_duration(result["contentDetails"]["duration"]))
            tlist.write(ytime+'\n')



#file merge for display

with open("ytstitle.txt",encoding="utf-8") as xh:
  with open('ytstime.txt') as yh:
    with open("ytsresult.txt","w",encoding="utf-8") as zh:
      xlines = xh.readlines()
      ylines = yh.readlines()
      for i in range(len(xlines)):
        line = ylines[i].strip() + '   ' + xlines[i]
        zh.write(line)
