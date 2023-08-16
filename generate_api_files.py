from json import load, dumps
from requests import get 

response = get("https://raw.githubusercontent.com/mohammedterryjack/quran-data/master/raw_data/mushaf/quran_en.json")
if response.ok:
    english = response.json()

with open('arabic/quran.json') as f:
    quran = load(f)
with open('arabic/surah_names.json') as f:
    chapters = load(f)
with open('arabic/tafsir/alJilani.json') as f:
    jilani = load(f)
with open('arabic/tafsir/bAjiba.json') as f:
    ajiba = load(f)
with open('arabic/tafsir/bArabi.json') as f:
    arabi = load(f)
with open('arabic/tafsir/zaydBAli.json') as f:
    zayd = load(f)

for id,verse in quran.items():
    chapter_no,verse_no = id.split('.')
    data = {
        "chapter":chapters[chapter_no],
        "text":verse,
        "translations":list(map(
            lambda text:{
                "translation":text,
                "language":"english",
                "translator":""
            },
            english[f"{chapter_no}:{verse_no}"]['ENGLISH'][:-2]
        )),
        "commentaries":[
            {
                "author":"ابن عباس",
                "year":"68",
                "text":"",
                "translations":[
                    {
                        "translation":english[f"{chapter_no}:{verse_no}"]['ENGLISH'][-2],
                        "language":'english',
                        'translator':'Mr. Mokrane Guezzou'
                    }
                ]
            },
            {
                "author":"زيد بن علي",
                "year":"120",
                "text":zayd[id],
                "translations":[]
            },
            {
                "author":"ابن عربي",
                "year":"638",
                "text":arabi[id],
                "translations":[]
            },
            {
                "author":"الجيلاني",
                "year":"713",
                "text":jilani[id],
                "translations":[]
            },
            {
                "author":"ابن عجيبة",
                "year":"1224",
                "text":ajiba[id],
                "translations":[]
            }
        ]
    }
    with open(f'api/{chapter_no}:{verse_no}.json','w') as f:
        f.write(dumps(data,indent=2,ensure_ascii=False))