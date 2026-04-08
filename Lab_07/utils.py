import math
from random import random

SCREEN_W = 800
SCREEN_H = 600

# Dźwięki
SOUND_SHOOTING = "assets/shoot.wav"
SOUND_EXPLOSION = "assets/explosion.wav"

# Inne
BACKGROUND_TEXTURE = "assets/stars.png"

# funkcja pomocnicza do rysowania "duchów" obiektów przy krawędziach ekranu
def ghost_positions(x: float, y: float, size: float) -> list[tuple[float, float]]:
    xs = [x]
    ys = [y]

    if x < size:
        xs.append(x + SCREEN_W)
    elif x > SCREEN_W - size:
        xs.append(x - SCREEN_W)

    if y < size:
        ys.append(y + SCREEN_H)
    elif y > SCREEN_H - size:
        ys.append(y - SCREEN_H)

    return [(px, py) for px in xs for py in ys]

# Funckja detekcji kolizji dwóch okręgów
def circles_collide(x1: float, y1: float, r1: float, x2: float, y2: float, r2: float) -> bool:
   distance = math.hypot(x2 - x1, y2 - y1)
   return distance < (r1 + r2)

# Funkcja generująca losowe pozycje i rozmiary asteroid
def generate_random_asteroid() -> tuple[float, float, float]:
    x = random() * SCREEN_W
    y = random() * SCREEN_H
    radius = random() * 40 + 20
    return (x, y, radius)