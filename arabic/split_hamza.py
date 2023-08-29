

from pydub import AudioSegment 
from pydub.silence import detect_silence 

chapter = 84
limits = [2.5,6.5,9,12,14.5,17,28,
    32,36,40.5,46.5,49,
    60.5,55,59,65,
    68,
    70,72.5,
    77,78.5,
    83.5,86,
    89.5,93,104
]


audio = AudioSegment.from_mp3(f"hamza/{chapter:03.0f}.mp3")
silence_segments = detect_silence(
    audio, 
    silence_thresh=-16, 
    min_silence_len=300,
)
start = 0
verse = 0
skipped = False
for _,end in silence_segments:
    limit = limits[verse]
    duration = end 
    duration /= 1000 
    print(duration, limit)
    if duration < limit:
        skipped = True
        continue
    audio[start:end].export(f"splits/{chapter}:{verse}.mp3",format='mp3')
    start = end
    verse += 1
    skipped = False 
if skipped:
    audio[start:end].export(f"splits/{chapter}:{verse}.mp3",format='mp3')
