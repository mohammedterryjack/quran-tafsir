from requests import get
from bs4 import BeautifulSoup
from json import dumps

results = {}
max_verses = list(get('https://raw.githubusercontent.com/mohammedterryjack/quran-tafsir/main/arabic/chapter_verses.json').json().values())
for chapter in range(1,115):
   max_verse = max_verses[chapter-1]
   for verse in range(1,max_verse+1):
        print(chapter,verse)
        response = get(f"https://quran.com/ar/{chapter}:{verse}/tafsirs/ar-tafseer-tanwir-al-miqbas")
        if response.ok:
            text = ''
            soup = BeautifulSoup(response.content, 'html.parser')
            for div in soup.find_all('div',{"class": "TafsirText_md__mJWtv"}):
                text += div.get_text() + '\n'
            results[f"{chapter}:{verse}"] = text
        else:
            print("ERROR")

with open('bAbbas_ar.json','w') as f:
    f.write(dumps(results,indent=2,ensure_ascii=False))
