# KONFIGURACJA GRY I STAŁE

from raylib import rl

# Ogólne
TARGET_FPS = 60
WAVE_DELAY = 2.0  # sekundy przerwy między falami

# Statek – parametry fizyczne
THRUST = 200
FRICTION = 65
ROTSPEED = 3.0
MAXSPEED = 300
BRAKE_FACTOR = 10.0

# Statek – geometria
VERTS = [(0, -15), (-10, 10), (10, 10)]
FLAME_VERTS = [(-6, 10), (6, 10), (0, 28)]
SHIP_SIZE = 15  # przybliżony promień do wykrywania kolizji

# Statek – kolory
COLOR_SHIP = [245, 245, 245, 255]
COLOR_FLAME = [255, 161, 0, 255]
COLOR_BULLET = [255, 255, 0, 255]
COLOR_DEBUG = [0, 228, 48, 255]

# Asteroidy – parametry ogólne
NUMBER_OF_ASTEROIDS = 3
ASTEROID_NUM_VERTS = 9
ASTEROID_RADIUS_JITTER = 0.35  # 35% losowego przesunięcia promienia
ASTEROID_ROT_SPEED_MIN = -1.5
ASTEROID_ROT_SPEED_MAX = 1.5

ASTEROID_FILL_COLOR_RGBA = (60, 60, 60, 255)
ASTEROID_LINE_COLOR_RGBA = (200, 200, 200, 255)

# Asteroidy – poziomy
ASTEROID_LEVELS = {
    3: (50, 70, 40, 80),    # duże
    2: (25, 40, 90, 150),   # średnie
    1: (10, 18, 160, 250),  # małe
}

# Punktacja
POINTS_MAP = {
    3: 20,   # duża
    2: 50,   # średnia
    1: 100   # mała
}

# Pociski
BULLET_SPEED = 320.0
BULLET_TTL = 1.5
BULLET_RADIUS = 2.0
MAX_BULLETS = 4

# Eksplozje
EXPLOSION_LIFETIME = 1.2
COLOR_EXPLOSION = [255, 69, 0, 255] 

# Kolizje
SHIP_COLLISION_RADIUS_RATIO = 0.8
SHIP_EXPLOSION_SCALE = 3.0
ASTEROID_EXPLOSION_SCALE = 2.0

# UI
HUD_FONT_SIZE_LARGE = 24
HUD_FONT_SIZE_SMALL = 20
MENU_TITLE_SIZE = 60
GAME_OVER_TITLE_SIZE = 40
