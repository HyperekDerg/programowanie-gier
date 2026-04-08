# Konfiguracja gry i stałe

TARGET_FPS = 60

# Statek
THRUST = 200
FRICTION = 65
ROTSPEED = 3.0
MAXSPEED = 300
VERTS = [(0, -15), (-10, 10), (10, 10)]
FLAME_VERTS = [(-6, 10), (6, 10), (0, 28)]
SHIP_SIZE = 15  # przybliżony promień do wykrywania widm

# Asteroidy
NUMBER_OF_ASTEROIDS = 6
ASTEROID_NUM_VERTS = 9
ASTEROID_RADIUS_JITTER = 0.35  # ±35% losowego przesunięcia promienia
ASTEROID_BASE_SPEED_MIN = 20.0
ASTEROID_BASE_SPEED_DIV = 120.0
ASTEROID_ROT_SPEED_MIN = -1.5
ASTEROID_ROT_SPEED_MAX = 1.5

# Pociski
BULLET_SPEED = 320.0
BULLET_TTL = 1.5  # czas życia pocisku
BULLET_RADIUS = 2.0
MAX_BULLETS = 4

# Eksplozje
EXPLOSION_LIFETIME = 1.2
