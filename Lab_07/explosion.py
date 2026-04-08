import pyray as rl
from config import EXPLOSION_LIFETIME


class Explosion:
    def __init__(self, x: float, y: float, target_radius: float):
        self.x = x
        self.y = y
        self.target_radius = target_radius
        self.current_radius = 0.0
        self.lifetime = EXPLOSION_LIFETIME
        self.timer = 0.0
        self.alive = True

    def update(self, dt: float) -> None:
        self.timer += dt
        # Proporcjonalne zwiększanie promienia względem czasu
        progress = self.timer / self.lifetime
        self.current_radius = progress * self.target_radius

        if self.timer >= self.lifetime:
            self.alive = False

    def draw(self) -> None:
        # Rysowanie rosnącego okręgu (konturu)
        alpha = int(255 * (1.0 - (self.timer / self.lifetime)))  # Zanikanie
        color = rl.color_alpha(rl.ORANGE, alpha / 255.0)
        rl.draw_circle_lines(int(self.x), int(self.y), self.current_radius, color)
