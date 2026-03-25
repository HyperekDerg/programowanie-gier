import math
import pyray as rl

THRUST = 200
FRICTION = 65
ROTSPEED = 3.0
MAXSPEED = 300
VERTS = [(0, -15), (-10, 10), (10, 10)]
FLAME_VERTS = [(-6, 10), (6, 10), (0, 28)]
DEBUG = False

# Funkcja do obracania punktu (x, y) o kąt angle
def rotate_point(x: float, y: float, angle: float) -> tuple[float, float]:
    cos_a = math.cos(angle)
    sin_a = math.sin(angle)
    return (x * cos_a - y * sin_a, x * sin_a + y * cos_a)

# Klasa reprezentująca statek kosmiczny
class Ship:
    def __init__(self, x: float, y: float):
        self.x = float(x)
        self.y = float(y)
        self.angle = 0.0
        self.vx = 0.0
        self.vy = 0.0
        self._thrusting = False

# Aktualizuje stan statku na podstawie czasu dt
    def update(self, dt: float) -> None:
        self._thrusting = False
        self._handle_rotation(dt)
        self._handle_thrust(dt)
        self._handle_brake(dt)
        self._apply_friction(dt)
        self._clamp_speed()
        self._move(dt)
        self._bounce_off_walls()

# Obsługuje obracanie statku na podstawie wciśniętych klawiszy
    def _handle_rotation(self, dt: float) -> None:
        if rl.is_key_down(rl.KeyboardKey.KEY_LEFT):
            self.angle -= ROTSPEED * dt
        if rl.is_key_down(rl.KeyboardKey.KEY_RIGHT):
            self.angle += ROTSPEED * dt

# Obsługuje przyspieszanie statku na podstawie wciśniętego klawisza
    def _handle_thrust(self, dt: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_UP):
            return
        self._thrusting = True
        nx = math.sin(self.angle)
        ny = -math.cos(self.angle)
        self.vx += nx * THRUST * dt
        self.vy += ny * THRUST * dt

# Obsługuje hamowanie statku na podstawie wciśniętego klawisza
    def _handle_brake(self, dt: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_Z):
            return
        factor = max(0.0, 1.0 - 10.0 * dt)
        self.vx *= factor
        self.vy *= factor
# Zastosowuje tarcie do prędkości statku
    def _apply_friction(self, dt: float) -> None:
        speed = math.hypot(self.vx, self.vy)
        if speed > 0:
            friction_force = min(FRICTION * dt, speed)
            self.vx -= (self.vx / speed) * friction_force
            self.vy -= (self.vy / speed) * friction_force

# Ogranicza prędkość statku do maksymalnej wartości
    def _clamp_speed(self) -> None:
        speed = math.hypot(self.vx, self.vy)
        if speed > MAXSPEED:
            scale = MAXSPEED / speed
            self.vx *= scale
            self.vy *= scale

# Aktualizuje pozycję statku na podstawie jego prędkości
    def _move(self, dt: float) -> None:
        self.x += self.vx * dt
        self.y += self.vy * dt

# Odbija statek od krawędzi ekranu
    def _bounce_off_walls(self) -> None:
        w = rl.get_screen_width()
        h = rl.get_screen_height()

        if self.x < 0:
            self.x = 0.0
            self.vx = abs(self.vx)
        elif self.x > w:
            self.x = float(w)
            self.vx = -abs(self.vx)

        if self.y < 0:
            self.y = 0.0
            self.vy = abs(self.vy)
        elif self.y > h:
            self.y = float(h)
            self.vy = -abs(self.vy)

# Rysuje statek na ekranie
    def draw(self) -> None:
        if self._thrusting:
            self._draw_flame()
        self._draw_hull()
        if DEBUG:
            self._draw_debug()

# Rysuje płomień silnika, gdy statek przyspiesza
    def _draw_flame(self) -> None:
        fw = self._world_verts(FLAME_VERTS)
        rl.draw_triangle_lines(
            rl.Vector2(fw[0][0], fw[0][1]),
            rl.Vector2(fw[1][0], fw[1][1]),
            rl.Vector2(fw[2][0], fw[2][1]),
            rl.ORANGE,
        )

# Rysuje kadłub statku
    def _draw_hull(self) -> None:
        vw = self._world_verts(VERTS)
        rl.draw_triangle_lines(
            rl.Vector2(vw[0][0], vw[0][1]),
            rl.Vector2(vw[1][0], vw[1][1]),
            rl.Vector2(vw[2][0], vw[2][1]),
            rl.WHITE,
        )

# Rysuje wektor prędkości i jego wartość, gdy włączony jest tryb debugowania
    def _draw_debug(self) -> None:
        speed = math.hypot(self.vx, self.vy)
        scale = 0.3
        rl.draw_line(
            int(self.x),
            int(self.y),
            int(self.x + self.vx * scale),
            int(self.y + self.vy * scale),
            rl.GREEN,
        )
        rl.draw_text(
            f"speed: {speed:.1f} px/s",
            int(self.x) + 15,
            int(self.y) - 10,
            14,
            rl.GREEN,
        )

# Przekształca lokalne współrzędne wierzchołków statku na współrzędne świata, uwzględniając pozycję i kąt obrotu statku
    def _world_verts(
        self, local_verts: list[tuple[float, float]]
    ) -> list[tuple[float, float]]:
        result = []
        for lx, ly in local_verts:
            rx, ry = rotate_point(lx, ly, self.angle)
            result.append((self.x + rx, self.y + ry))
        return result
