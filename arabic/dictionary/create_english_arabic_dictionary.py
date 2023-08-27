from nltk.corpus import wordnet, brown
from nltk import FreqDist
from unicodedata import normalize, combining
from json import dumps


def remove_diacritics(arabic_text:str) -> str:
    normalized_text = normalize('NFKD', arabic_text)
    return ''.join([c for c in normalized_text if not combining(c)]).replace("أ", "ا").replace('ٱ',"ا").replace("ـ", "").replace('_',' ')

freq_dist = FreqDist(brown.words())
rarity_threshold = 50  

results = {}
for word in wordnet.words():
    for synset in wordnet.synsets(word):
        arabic_synset = synset.lemma_names(lang="arb")
        if not any(arabic_synset):
            continue
        word_frequency = freq_dist[word]
        if word_frequency<rarity_threshold:
            continue
        pos = synset.pos()
        print(word)
        print(arabic_synset)
        for lemma in list(map(lambda word:word.replace('-',' ').replace('_',' '), synset.lemma_names())):
            lemma_frequency = freq_dist[lemma]
            if lemma_frequency<rarity_threshold:
                continue
            lemma = lemma.lower()
            for arabic_word in arabic_synset:
                arabic_word = remove_diacritics(arabic_word)
                if arabic_word.isdigit() or len(arabic_word.split())>1:
                    continue
                if lemma not in results:
                    results[lemma] = {}
                if pos not in results[lemma]:
                    results[lemma][pos] = set()
                results[lemma][pos].add(arabic_word)
for word,arabic in results.items():
    result = []
    for pos,values in arabic.items():
        result.append(f"{word} ({pos}): {'، '.join(sorted(values))}")
    results[word] = '\n\n'.join(result)

with open('dictionary.json','w') as f:
    f.write(dumps(results,indent=2,ensure_ascii=False))
