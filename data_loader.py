from json import load
from typing import Dict

from utils import Commentators, DataLabel


class DataLoader:
    def __init__(self) -> None:
        with open("arabic/quran.json") as f:
            self.__quran = load(f)
        with open("arabic/surah_names.json") as f:
            self.surah_names = load(f)
        with open("arabic/tafsir/zaydBAli.json") as f:
            self.__tafsir_zayd = load(f)
        with open("arabic/tafsir/alJilani.json") as f:
            self.__tafsir_jilani = load(f)
        with open("arabic/tafsir/bAjiba.json") as f:
            self.__tafsir_bAjiba = load(f)
        with open("arabic/tafsir/bArabi.json") as f:
            self.__tafsir_bArabi = load(f)

    def get(self, chapter: int, verse: int) -> Dict[str, str]:
        if str(chapter) not in self.surah_names:
            return {
                DataLabel.ERROR.value: True,
                DataLabel.MESSAGE.value: "Invalid Surah Number",
            }
        id = f"{chapter}.{verse}"
        if id not in self.__quran:
            return {
                DataLabel.ERROR.value: True,
                DataLabel.MESSAGE.value: "Invalid Ayah Number",
            }
        return {
            DataLabel.ERROR.value: False,
            DataLabel.CHAPTER.value: self.surah_names[str(chapter)],
            DataLabel.CHAPTER_NO.value: chapter,
            DataLabel.VERSE_NO.value: verse,
            DataLabel.VERSE.value: self.__quran[id],
            DataLabel.COMMENTARY.value: {
                Commentators.ZAYD.value: self.__tafsir_zayd[id],
                Commentators.ARABI.value: self.__tafsir_bArabi[id],
                Commentators.AJIBA.value: self.__tafsir_bAjiba[id],
                Commentators.JILANI.value: self.__tafsir_jilani[id],
            },
        }
