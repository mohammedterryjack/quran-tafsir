from enum import Enum

from kivy.uix.button import Button
from kivy.uix.label import Label


class DataLabel(Enum):
    CHAPTER = "Surah Name"
    CHAPTER_NO = "Surah Number"
    VERSE_NO = "Ayah"
    VERSE = "Qur'an"
    COMMENTARY = "Tafasir"
    ERROR = "error"
    MESSAGE = "message"


class Commentators(Enum):
    ZAYD = "Zayd b. 'Ali"
    ARABI = "b. 'Arabi"
    AJIBA = "b. 'Ajiba"
    JILANI = "'Abd al-Qadir al-Jilani"


class DropdownSelection(Button):
    def __init__(self, id: int, **kwargs) -> None:
        self.id = id
        super().__init__(**kwargs)


class WrappedLabel(Label):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.bind(
            width=lambda *x: self.setter("text_size")(
                self, (self.width - sum(self.padding), None)
            ),
            texture_size=lambda *x: self.setter("height")(self, self.texture_size[1]),
        )
