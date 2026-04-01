import math
import pyray as rl
from config import THRUST, FRICTION, ROTSPEED, MAXSPEED, VERTS, FLAME_VERTS, SHIP_SIZE
from utils import SCREEN_W, SCREEN_H, ghost_positions

DEBUG = False


def rotate_point(x: float, y: float, angle: float) -> tuple[float, float]:
    cos_a = math.cos(angle)
    sin_a = math.sin(angle)
    return (x * cos_a - y * sin_a, x * sin_a + y * cos_a)


class Ship:
    def __init__(self, x: float, y: float):
        self.x = float(x)
        self.y = float(y)
        self.angle = 0.0
        self.vx = 0.0
        self.vy = 0.0
        self._thrusting = False

    def update(self, dt: float) -> None:
        self._thrusting = False
        self._handle_rotation(dt)
        self._handle_thrust(dt)
        self._handle_brake(dt)
        self._apply_friction(dt)
        self._clamp_speed()
        self._move(dt)

    # Zawijanie pozycji przez modulo
    def wrap(self) -> None:
        self.x %= SCREEN_W
        self.y %= SCREEN_H

    # obsłiga rotacji
    def _handle_rotation(self, dt: float) -> None:
        if rl.is_key_down(rl.KeyboardKey.KEY_LEFT):
            self.angle -= ROTSPEED * dt
        if rl.is_key_down(rl.KeyboardKey.KEY_RIGHT):
            self.angle += ROTSPEED * dt

    # obsługa przyspieszenia
    def _handle_thrust(self, dt: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_UP):
            return
        self._thrusting = True
        nx = math.sin(self.angle)
        ny = -math.cos(self.angle)
        self.vx += nx * THRUST * dt
        self.vy += ny * THRUST * dt

    # obsługa hamowania
    def _handle_brake(self, dt: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_Z):
            return
        factor = max(0.0, 1.0 - 10.0 * dt)
        self.vx *= factor
        self.vy *= factor

    # tarcie redukuje prędkość o stałą wartość, niezależnie od kierunku
    def _apply_friction(self, dt: float) -> None:
        speed = math.hypot(self.vx, self.vy)
        if speed > 0:
            friction_force = min(FRICTION * dt, speed)
            self.vx -= (self.vx / speed) * friction_force
            self.vy -= (self.vy / speed) * friction_force

    # ograniczenie prędkości do MAXSPEED
    def _clamp_speed(self) -> None:
        speed = math.hypot(self.vx, self.vy)
        if speed > MAXSPEED:
            scale = MAXSPEED / speed
            self.vx *= scale
            self.vy *= scale

    # aktualizacja pozycji na podstawie prędkości
    def _move(self, dt: float) -> None:
        self.x += self.vx * dt
        self.y += self.vy * dt

    # rysowanie widm dla każdej pozycji z ghost_positions
    def draw(self) -> None:
        for px, py in ghost_positions(self.x, self.y, SHIP_SIZE):
            self._draw_at(px, py)

    def _draw_at(self, cx: float, cy: float) -> None:
        if self._thrusting:
            self._draw_flame_at(cx, cy)
        self._draw_hull_at(cx, cy)
        if DEBUG:
            self._draw_debug_at(cx, cy)

    def _draw_flame_at(self, cx: float, cy: float) -> None:
        fw = self._world_verts(FLAME_VERTS, cx, cy)
        rl.draw_triangle_lines(
            rl.Vector2(fw[0][0], fw[0][1]),
            rl.Vector2(fw[1][0], fw[1][1]),
            rl.Vector2(fw[2][0], fw[2][1]),
            rl.ORANGE,
        )

    def _draw_hull_at(self, cx: float, cy: float) -> None:
        vw = self._world_verts(VERTS, cx, cy)
        rl.draw_triangle_lines(
            rl.Vector2(vw[0][0], vw[0][1]),
            rl.Vector2(vw[1][0], vw[1][1]),
            rl.Vector2(vw[2][0], vw[2][1]),
            rl.WHITE,
        )

    def _draw_debug_at(self, cx: float, cy: float) -> None:
        speed = math.hypot(self.vx, self.vy)
        scale = 0.3
        rl.draw_line(
            int(cx),
            int(cy),
            int(cx + self.vx * scale),
            int(cy + self.vy * scale),
            rl.GREEN,
        )
        rl.draw_text(
            f"speed: {speed:.1f} px/s",
            int(cx) + 15,
            int(cy) - 10,
            14,
            rl.GREEN,
        )

    def _world_verts(
        self,
        local_verts: list[tuple[float, float]],
        cx: float,
        cy: float,
    ) -> list[tuple[float, float]]:
        result = []
        for lx, ly in local_verts:
            rx, ry = rotate_point(lx, ly, self.angle)
            result.append((cx + rx, cy + ry))
        return result
