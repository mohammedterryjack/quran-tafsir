from nltk.corpus import wordnet, brown
from nltk import FreqDist, download
from unicodedata import normalize, combining
from json import dumps


def remove_diacritics(arabic_text:str) -> str:
    normalized_text = normalize('NFKD', arabic_text)
    return ''.join([c for c in normalized_text if not combining(c)]).replace("أ", "ا").replace('ٱ',"ا").replace("ـ", "").replace('_',' ')

freq_dist = FreqDist(brown.words())
rarity_threshold = 100  

results = {}
for word in wordnet.words():
    for synset in wordnet.synsets(word):
        arabic_synset = synset.lemma_names(lang="arb")
        if not any(arabic_synset):
            continue
        word_frequency = freq_dist[word]
        if word_frequency<rarity_threshold:
            continue
        print(word)
        print(arabic_synset)
        for lemma in list(map(lambda word:word.replace('-',' ').replace('_',' '), synset.lemma_names())):            
            lemma_frequency = freq_dist[lemma]
            if lemma_frequency<rarity_threshold:
                continue
            for arabic_word in arabic_synset:
                arabic_word = remove_diacritics(arabic_word)
                if arabic_word.isdigit():
                    continue
                if lemma not in results:
                    results[lemma] = set()
                results[lemma].add(arabic_word)
    
    
with open('english_arabic_dictionary.json','w') as f:
    f.write(dumps(results,indent=2,ensure_ascii=False,default=list))