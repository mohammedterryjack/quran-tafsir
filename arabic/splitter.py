
from tkinter import Button, Tk, Label, Scale
from pygame import mixer
from pydub import AudioSegment
from requests import get 
from argparse import ArgumentParser
from os.path import exists

parser = ArgumentParser(description="Audio Editor App")
parser.add_argument("--chapter", type=int, help="Chapter number")
args = parser.parse_args()
chapter = args.chapter

AUDIOFILE = f"{chapter}.mp3"
if not exists(AUDIOFILE):
    with open(AUDIOFILE, "wb") as file:
        file.write(get(f"https://github.com/mohammedterryjack/quran-data/raw/master/raw_data/audio_to_split/hamza_nuh/{chapter:03.0f}.mp3").content)
QURAN = get("https://raw.githubusercontent.com/mohammedterryjack/quran-tafsir/main/arabic/quran.json").json()


class AudioEditorApp:
    def __init__(self, root):
        self.marked_timestamps = []
        self.audio = AudioSegment.from_mp3(AUDIOFILE)
        self.pause_time = 0

        mixer.init()
        mixer.music.load(AUDIOFILE)

        self.root = root
        self.root.title("Audio Editor")
        key = f"{chapter}.{len(self.marked_timestamps)}"
        self.root.title(key)
        self.verse = Label(self.root, text="bismillahi...", font=("Helvetica", 20), fg="blue")
        self.verse.pack()

        self.play_button = Button(self.root, text="Play", command=self.play_audio)
        self.play_button.pack()

        self.mark_button = Button(self.root, text="Mark Timestamp", command=self.mark_timestamp)
        self.mark_button.pack()

        self.undo_button = Button(self.root, text="Undo", command=self.unmark_timestamp)
        self.undo_button.pack()

        self.audio_timer = Scale(self.root, from_=0, to=self.audio.duration_seconds, orient="horizontal", length=300)
        self.audio_timer.pack()

        self.root.after(100, self.update_slider_position)

    def update_slider_position(self):
        now = self.pause_time + mixer.music.get_pos() 
        if now != 0:
            now /= 1000
        self.audio_timer.set(now)
        self.root.after(100, self.update_slider_position)

    def play_audio(self):
        mixer.music.play(start=self.pause_time/1000 if self.pause_time else 0)

    def unmark_timestamp(self):
        mixer.music.stop()
        self.marked_timestamps.pop()
        verse = len(self.marked_timestamps)
        key = f"{chapter}.{verse}"
        self.root.title(key)
        self.verse.config(text="bismillahi..." if verse == 0 else QURAN[key])
        self.pause_time = self.marked_timestamps[-1] if any(self.marked_timestamps) else 0

    def mark_timestamp(self):
        self.marked_timestamps.append(self.pause_time + mixer.music.get_pos())
        key = f"{chapter}.{len(self.marked_timestamps)}"
        self.root.title(key)
        try:
            self.verse.config(text=QURAN[key])
        except:
            with open(f'{chapter}.txt','w') as f:
                f.write('\n'.join(map(str,self.marked_timestamps)))
            #self.split_audio()

    def split_audio(self):
        previous_timestamp = 0
        for verse, timestamp in enumerate(self.marked_timestamps):
            segment = self.audio[previous_timestamp:timestamp]
            segment.export(f"output_audio/{chapter}:{verse}.mp3", format="mp3")
            previous_timestamp = timestamp

if __name__ == "__main__":
    root = Tk()
    app = AudioEditorApp(root)
    root.mainloop()