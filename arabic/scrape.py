from requests import get
from bs4 import BeautifulSoup
from json import dumps


max_verses = get('https://raw.githubusercontent.com/mohammedterryjack/quran-tafsir/main/arabic/chapter_verses.json').json().values()
tafsir_ids = {
    #'bArabi':33,
    'bAjiba':37,
    'alJilani':95,
}

for tafsir,id in tafsir_ids.items():
    results = {}
    for chapter,max_verse in zip(range(1,115),max_verses):
        for verse in range(1,max_verse+1):
            result = []
            page = 1
            while True:
                print(tafsir,chapter,verse,page)
                endpoint = f"https://www.altafsir.com/Tafasir.asp?tMadhNo=0&tTafsirNo={id}&tSoraNo={chapter}&tAyahNo={verse}&tDisplay=yes&Page={page}&Size=1&LanguageId=1"
                response = get(endpoint)
                if response.ok:
                    soup = BeautifulSoup(response.content, 'html.parser')
                    for div in soup.find_all('div', id='SearchResults'):
                        for font in div.find_all('font', class_='TextResultArabic'):
                            result.append(font.text)
                    for link in soup.find_all('a'):
                        try:
                            href = link['href']
                        except:
                            href = ''
                        if href.startswith('Javascript:InnerLink_onchange('):
                            _,finalPage,_ = href.split(',')
                            finalPage = int(finalPage)
                else:
                    print(response.message)
                if page < finalPage:
                    page += 1
                else:
                    break
            results[f"{chapter}.{verse}"] = '\n'.join(result)
    with open(f'{tafsir}/results.json','w') as f:
        f.write(dumps(results,indent=2,ensure_ascii=False))