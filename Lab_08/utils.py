import math
import random

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
def generate_random_asteroid() -> tuple[float, float, int]:
    x = random.random() * SCREEN_W
    y = random.random() * SCREEN_H
    level = random.choices([3, 2, 1], weights=[0.5, 0.3, 0.2])[0]  # większe asteroidy są bardziej prawdopodobne
    return (x, y, level)

def cleanup_dead_entities(entities_list):
    entities_list[:] = [item for item in entities_list if item.alive]
    
def rotate_point(x: float, y: float, angle: float) -> tuple[float, float]:
    cos_a = math.cos(angle)
    sin_a = math.sin(angle)
    return (x * cos_a - y * sin_a, x * sin_a + y * cos_a)
