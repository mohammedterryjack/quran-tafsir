from typing import Optional

from arabic_reshaper import reshape
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.dropdown import DropDown
from kivy.uix.image import Image
from kivy.uix.popup import Popup
from kivy.uix.relativelayout import RelativeLayout
from kivy.uix.textinput import TextInput

from data_loader import DataLoader
from utils import Commentators, DataLabel, DropdownSelection, WrappedLabel


class Quran(App):
    def __init__(self) -> None:
        super().__init__()
        self.data = DataLoader()
        self.current_chapter = 1
        self.current_verse = 1
        self.current_commentator = None

    def error(self, message: str) -> None:
        Popup(
            title="Error",
            content=WrappedLabel(text=message),
            size_hint=(None, None),
            size=(400, 200),
        ).open()

    def display(
        self,
        chapter: Optional[int] = None,
        verse: Optional[int] = None,
        commentator: Optional[str] = None,
    ) -> None:
        if chapter is None:
            chapter = self.current_chapter
        if verse is None:
            verse = self.current_verse
        data = self.data.get(chapter=chapter, verse=verse)
        if data[DataLabel.ERROR.value]:
            self.error(message=data[DataLabel.MESSAGE.value])
            return
        self.update_bookmark(chapter=chapter, verse=verse, commentator=commentator)
        self.update_displays(
            title=data[DataLabel.CHAPTER.value],
            text=f"{data[DataLabel.VERSE.value]} ({str(self.current_verse)[::-1]})",
            commentary=""
            if self.current_commentator is None
            else data[DataLabel.COMMENTARY.value][self.current_commentator].replace(
                "\n", " "
            ),
        )

    def update_bookmark(self, chapter: int, verse: int, commentator: str) -> None:
        self.current_chapter = chapter
        self.current_verse = verse
        if commentator is not None:
            if commentator == self.current_commentator:
                self.current_commentator = None
            else:
                self.current_commentator = commentator

    def update_displays(self, title: str, text: str, commentary: str) -> None:
        self.verse_select.text = str(self.current_verse)
        self.surah_names_button.text = reshape(title)
        self.verse_number_label.text = reshape(f"سورة {title}")
        self.verse_label.text = reshape(text)
        self.commentary_label.text = reshape(commentary)

    def build(self) -> RelativeLayout:
        layout = RelativeLayout()
        layout.add_widget(
            Image(
                source="assets/images/parchment.jpeg",
                allow_stretch=True,
                keep_ratio=False,
            )
        )
        layout.add_widget(self.build_header())
        layout.add_widget(self.build_body())
        layout.add_widget(self.build_footer())
        self.display(chapter=1, verse=1)
        return layout

    def build_body(self) -> BoxLayout:
        self.verse_label = WrappedLabel(
            text="",
            font_size="45sp",
            font_name="assets/fonts/noto_naskh.ttf",
            font_direction="rtl",
            halign="center",
            color=(0.2, 0.2, 0.2, 1),
            padding=(30, 30),
        )
        self.commentary_label = WrappedLabel(
            text="",
            font_size="15sp",
            bold=True,
            font_name="assets/fonts/noto_naskh.ttf",
            font_direction="rtl",
            halign="right",
            color=(0.2, 0.2, 0.2, 1),
            padding=(30, 30),
            pos=(200, 200),
        )
        body = BoxLayout(orientation="vertical")
        body.add_widget(self.verse_label)
        body.add_widget(self.commentary_label)
        return body

    def build_header(self) -> BoxLayout:
        self.verse_number_label = WrappedLabel(
            text="",
            font_size="30sp",
            font_name="assets/fonts/noto_naskh.ttf",
            font_direction="rtl",
            halign="center",
            color=(1, 0, 0, 1),
            padding=(30, 30),
        )
        header = BoxLayout(orientation="horizontal")
        header.add_widget(self.verse_number_label)
        return header

    def build_footer(self) -> BoxLayout:
        surah_options = DropDown()
        for surah_number, surah_name in self.data.surah_names.items():
            button = DropdownSelection(
                id=surah_number,
                text=reshape(surah_name),
                font_name="assets/fonts/noto_naskh.ttf",
                font_direction="rtl",
                size_hint_y=None,
                height=44,
            )
            button.bind(on_release=lambda choice: self.display(chapter=choice.id))
            surah_options.add_widget(button)
        self.surah_names_button = Button(
            text=reshape("سورة"),
            font_name="assets/fonts/noto_naskh.ttf",
            font_direction="rtl",
            size_hint=(None, None),
            size=(150, 40),
        )
        self.surah_names_button.bind(on_release=surah_options.open)
        self.verse_select = TextInput(
            text=str(self.current_verse),
            multiline=False,
            size_hint=(None, None),
            size=(50, 40),
            halign="center",
        )
        previous_verse_button = Button(text="-", size_hint=(None, None), size=(50, 40))
        previous_verse_button.bind(
            on_press=lambda _: self.display(verse=self.current_verse - 1)
        )
        next_verse_button = Button(text="+", size_hint=(None, None), size=(50, 40))
        next_verse_button.bind(
            on_press=lambda _: self.display(verse=self.current_verse + 1)
        )
        footer = BoxLayout(orientation="horizontal")
        for commentator in Commentators:
            tab = Button(
                text=commentator.value,
                on_press=lambda x: self.display(commentator=x.text),
                size_hint=(None, None),
                size=(300, 40),
            )
            footer.add_widget(tab)
        footer.add_widget(self.surah_names_button)
        footer.add_widget(previous_verse_button)
        footer.add_widget(self.verse_select)
        footer.add_widget(next_verse_button)
        return footer


if __name__ == "__main__":
    Quran().run()
