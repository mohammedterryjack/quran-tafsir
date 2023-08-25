
from os import listdir
from typing import List 
from json import load,dumps 


def load_filenames(target_directory: str, file_type: str) -> List[str]:
    filenames = listdir(target_directory)
    image_filenames = list(
        filter(
            lambda filename: filename.endswith(file_type),
            filenames,
        )
    )
    return list(map(lambda filename: target_directory + filename, image_filenames))


for filename in load_filenames(target_directory="quran-api/",file_type='.json'):
    name = filename.replace('quran-api/','').replace('.json','')
    print(name)
    if name == 'metadata':
        continue
    chapter,verse = name.split(':')
    with open(filename) as f:
        data = load(f)
    for style,audio in zip(['hafs','warsh','hamza'],data['audio']):
        audio['path'] = f"https://github.com/mohammedterryjack/quran-audio-api/raw/main/{style}/{chapter}:{verse}.mp3"
    with open(filename,'w') as f:
        f.write(dumps(data,indent=2,ensure_ascii=False))