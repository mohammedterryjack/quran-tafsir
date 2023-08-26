from json import load, dumps
from re import findall
from typing import Generator, List 
from requests import get
from unicodedata import normalize, combining

def remove_diacritics(arabic_text:str) -> str:
    normalized_text = normalize('NFKD', arabic_text)
    return ''.join([c for c in normalized_text if not combining(c)]).replace("أ", "ا").replace('ٱ',"ا").replace("ـ", "").replace("ا",'').replace('و','').strip()

def belongs_to_this_verse(quotes:List[str],verse:str) -> bool:
    if len(quotes) <= 3:
        return all(quote in verse for quote in quotes)
    count = 0
    for quote in quotes:
        if quote in verse:
            count += 1
    return count >= len(quotes)-1

def extract_quranic_quotes(text:str) -> Generator[str,None,None]:
    for quote in findall(r'\{(.*?)\}', text):
        yield remove_diacritics(quote)

with open('alJilani/alJilani_raw.json') as f:
    data=load(f)

arabics = list(data.values())
verses = list(data.keys())
texts = []
clusters = []
for index,arabic in enumerate(arabics):
    key = verses[index]
    if index > 0 and arabic.strip() == arabics[index-1].strip():
        clusters[-1].append(key)
    else:
        clusters.append([key])
        texts.append(arabic)


quran = get('https://raw.githubusercontent.com/mohammedterryjack/quran-tafsir/main/arabic/quran.json').json()

results = {}
for verses,text in zip(clusters,texts):
    if len(verses)== 1:
        results[verses[0]] = text
        continue
    subtexts = text.replace('.','\n').replace(',','\n').replace("،",'\n').replace("؛",'\n').replace(".",'\n').split('\n')
    for index,verse in enumerate(verses):
        results[verse] = ''
        verse_text = remove_diacritics(quran[verse])
        if index == len(verses)-2:
            next_next_verse = None
            next_next_verse_text = ''
            next_verse = verses[index+1]
            next_verse_text = remove_diacritics(quran[next_verse])
        elif index == len(verses)-1:
            next_next_verse = None
            next_next_verse_text = ''
            next_verse = None
            next_verse_text = ''
        else:
            next_next_verse = verses[index+2]
            next_next_verse_text = remove_diacritics(quran[next_next_verse])
            next_verse = verses[index+1]
            next_verse_text = remove_diacritics(quran[next_verse])
        while any(subtexts):
            subtext = subtexts.pop(0)        
            quotes = list(extract_quranic_quotes(text=subtext))
            
            if any(quotes) and (
                belongs_to_this_verse(quotes,next_verse_text)
                or belongs_to_this_verse(quotes, next_next_verse_text)
            ) and not all(quote in verse_text for quote in quotes):
                subtexts = [subtext] + subtexts
                break
            results[verse] += '\n' + subtext
with open('alJilani/alJilani.json','w') as f:
    f.write(dumps(results,indent=2,ensure_ascii=False))
