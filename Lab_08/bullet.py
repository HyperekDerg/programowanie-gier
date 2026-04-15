import math
import pyray as rl
from utils import SCREEN_W, SCREEN_H
from config import (
    BULLET_SPEED,
    BULLET_TTL,
    BULLET_RADIUS,
)


class Bullet:
    def __init__(self, x: float, y: float, angle: float):
        self.x = float(x)
        self.y = float(y)
        self.angle = angle

        self.speed = BULLET_SPEED
        self.radius = BULLET_RADIUS
        self.time_to_live = BULLET_TTL
        self.alive = True

        # Obliczanie wektora prędkości na podstawie kąta
        self.velocity_x = math.sin(self.angle) * self.speed
        self.velocity_y = -math.cos(self.angle) * self.speed

    def update(self, delta_time: float) -> None:
        if not self.alive:
            return

        self.x += self.velocity_x * delta_time
        self.y += self.velocity_y * delta_time

        self.time_to_live -= delta_time
        if self.time_to_live <= 0:
            self.alive = False

        self._wrap_position()

    def _wrap_position(self) -> None:
        self.x %= SCREEN_W
        self.y %= SCREEN_H

    def draw(self) -> None:
        if not self.alive:
            return

        rl.draw_circle(int(self.x), int(self.y), self.radius, rl.YELLOW)
