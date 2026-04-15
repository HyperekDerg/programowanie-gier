import math
import random
import pyray as rl
from config import (
    ASTEROID_NUM_VERTS,
    ASTEROID_RADIUS_JITTER,
    ASTEROID_BASE_SPEED_MIN,
    ASTEROID_BASE_SPEED_DIV,
    ASTEROID_ROT_SPEED_MIN,
    ASTEROID_ROT_SPEED_MAX,
)
from utils import SCREEN_W, SCREEN_H, ghost_positions


# Funkcja pomocnicza do obracania punktu o dany kąt
def rotate_point(x: float, y: float, angle: float) -> tuple[float, float]:
    cos_a = math.cos(angle)
    sin_a = math.sin(angle)
    return (x * cos_a - y * sin_a, x * sin_a + y * cos_a)


class Asteroid:
    def __init__(self, x: float, y: float, radius: float):
        self.x = float(x)
        self.y = float(y)
        self.radius = float(radius)
        self.alive = True

        # Większe asteroidy poruszają się wolniej
        base_speed = max(ASTEROID_BASE_SPEED_MIN, ASTEROID_BASE_SPEED_DIV / radius)
        angle = random.uniform(0, 2 * math.pi)
        self.vx = math.cos(angle) * base_speed
        self.vy = math.sin(angle) * base_speed

        # Losowa prędkość kątowa
        self.rot_speed = random.uniform(ASTEROID_ROT_SPEED_MIN, ASTEROID_ROT_SPEED_MAX)
        self.angle = random.uniform(0, 2 * math.pi)

        # Proceduralne wierzchołki asteroidy
        self._local_verts = self._generate_verts()

    def _generate_verts(self) -> list[tuple[float, float]]:
        verts = []
        for i in range(ASTEROID_NUM_VERTS):
            base_angle = (2 * math.pi * i) / ASTEROID_NUM_VERTS
            r = self.radius * random.uniform(
                1.0 - ASTEROID_RADIUS_JITTER, 1.0 + ASTEROID_RADIUS_JITTER
            )
            verts.append((math.cos(base_angle) * r, math.sin(base_angle) * r))
        return verts

    def update(self, dt: float) -> None:
        self.x += self.vx * dt
        self.y += self.vy * dt
        self.angle += self.rot_speed * dt
        self.wrap()

    def wrap(self) -> None:
        self.x %= SCREEN_W
        self.y %= SCREEN_H

    def draw(self) -> None:
        for px, py in ghost_positions(self.x, self.y, self.radius):
            self._draw_at(px, py)

    def _draw_at(self, cx: float, cy: float) -> None:
        world = []
        for lx, ly in self._local_verts:
            rx, ry = rotate_point(lx, ly, self.angle)
            world.append((cx + rx, cy + ry))

        n = len(world)
        fill_color = rl.Color(60, 60, 60, 255)
        center = rl.Vector2(cx, cy)

        for i in range(n):
            v1 = rl.Vector2(*world[i])
            v2 = rl.Vector2(*world[(i + 1) % n])
            rl.draw_triangle(center, v2, v1, fill_color)

        for i in range(n):
            x1, y1 = world[i]
            x2, y2 = world[(i + 1) % n]
            rl.draw_line(int(x1), int(y1), int(x2), int(y2), rl.GRAY)
