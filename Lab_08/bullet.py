import math
import pyray as rl
from utils import SCREEN_W, SCREEN_H
from config import BULLET_SPEED, BULLET_TTL, BULLET_RADIUS

class Bullet:
    def __init__(self, x: float, y: float, angle: float):
        self.x = float(x)
        self.y = float(y)
        self.angle = angle

        self.speed = BULLET_SPEED
        self.radius = BULLET_RADIUS
        self.ttl = BULLET_TTL
        self.alive = True

        self.vx = math.sin(self.angle) * self.speed
        self.vy = -math.cos(self.angle) * self.speed

    def update(self, dt: float) -> None:
        if not self.alive:
            return

        self.x += self.vx * dt
        self.y += self.vy * dt

        self.ttl -= dt
        if self.ttl <= 0:
            self.alive = False

        self.wrap()

    def wrap(self) -> None:
        self.x %= SCREEN_W
        self.y %= SCREEN_H

    def draw(self) -> None:
        if self.alive:
            rl.draw_circle(int(self.x), int(self.y), self.radius, rl.YELLOW)
