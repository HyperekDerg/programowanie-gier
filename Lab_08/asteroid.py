import math
import random
import pyray as rl
from config import (
    ASTEROID_NUM_VERTS,
    ASTEROID_RADIUS_JITTER,
    ASTEROID_ROT_SPEED_MIN,
    ASTEROID_ROT_SPEED_MAX,
    ASTEROID_LEVELS,
    ASTEROID_FILL_COLOR_RGBA,
    ASTEROID_LINE_COLOR_RGBA,
)
from utils import SCREEN_W, SCREEN_H, ghost_positions, rotate_point


class Asteroid:
    def __init__(self, x: float, y: float, level: int = 3):
        self.x = float(x)
        self.y = float(y)
        self.level = level
        self.alive = True

        # Pobieranie parametrów poziomu
        level_params = ASTEROID_LEVELS.get(level, ASTEROID_LEVELS[3])
        min_radius, max_radius, min_speed, max_speed = level_params

        # Inicjalizacja fizyki
        self.radius = float(random.uniform(min_radius, max_radius))
        self.angle = random.uniform(0, 2 * math.pi)
        self.rot_speed = random.uniform(ASTEROID_ROT_SPEED_MIN, ASTEROID_ROT_SPEED_MAX)

        move_speed = random.uniform(min_speed, max_speed)
        move_direction = random.uniform(0, 2 * math.pi)
        self.vx = math.cos(move_direction) * move_speed
        self.vy = math.sin(move_direction) * move_speed

        self._local_verts = self._generate_verts()

    def split(self) -> list["Asteroid"]:
        if self.level <= 1:
            return []
        return [Asteroid(self.x, self.y, self.level - 1) for _ in range(2)]

    def _generate_verts(self) -> list[tuple[float, float]]:
        verts = []
        for i in range(ASTEROID_NUM_VERTS):
            base_angle = (2 * math.pi * i) / ASTEROID_NUM_VERTS
            jitter = random.uniform(
                1.0 - ASTEROID_RADIUS_JITTER, 1.0 + ASTEROID_RADIUS_JITTER
            )
            dist = self.radius * jitter
            verts.append((math.cos(base_angle) * dist, math.sin(base_angle) * dist))
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
        for ghost_x, ghost_y in ghost_positions(self.x, self.y, self.radius):
            self._draw_at(ghost_x, ghost_y)

    def _draw_at(self, center_x: float, center_y: float) -> None:
        world_verts = []
        for local_x, local_y in self._local_verts:
            rx, ry = rotate_point(local_x, local_y, self.angle)
            world_verts.append(rl.Vector2(center_x + rx, center_y + ry))

        self._render_asteroid_shape(center_x, center_y, world_verts)

    def _render_asteroid_shape(
        self, cx: float, cy: float, verts: list[rl.Vector2]
    ) -> None:
        num_verts = len(verts)
        center_vec = rl.Vector2(cx, cy)

        # Konwersja list z configu na obiekty Color Rayliba
        fill_color = rl.Color(*ASTEROID_FILL_COLOR_RGBA)
        line_color = rl.Color(*ASTEROID_LINE_COLOR_RGBA)

        # Rysowanie wypełnienia
        for i in range(num_verts):
            v1 = verts[i]
            v2 = verts[(i + 1) % num_verts]
            rl.draw_triangle(center_vec, v2, v1, fill_color)

        # Rysowanie krawędzi
        for i in range(num_verts):
            rl.draw_line_v(verts[i], verts[(i + 1) % num_verts], line_color)
