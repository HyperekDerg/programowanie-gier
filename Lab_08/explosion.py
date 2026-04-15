import pyray as rl
from config import EXPLOSION_LIFETIME, COLOR_EXPLOSION


class Explosion:
    def __init__(self, x: float, y: float, target_radius: float):
        self.x = float(x)
        self.y = float(y)
        self.target_radius = target_radius
        self.current_radius = 0.0
        self.max_lifetime = EXPLOSION_LIFETIME
        self.elapsed_time = 0.0
        self.alive = True

    def update(self, delta_time: float) -> None:
        if not self.alive:
            return

        self.elapsed_time += delta_time

        progress = self.elapsed_time / self.max_lifetime
        self.current_radius = progress * self.target_radius

        if self.elapsed_time >= self.max_lifetime:
            self.alive = False

    def draw(self) -> None:
        if not self.alive:
            return

        # Obliczanie zanikania (alpha)
        fade_factor = 1.0 - (self.elapsed_time / self.max_lifetime)

        # Pobieranie koloru bazowego i nakładanie przezroczystości
        base_color = rl.Color(*COLOR_EXPLOSION)
        faded_color = rl.color_alpha(base_color, fade_factor)

        rl.draw_circle_lines(int(self.x), int(self.y), self.current_radius, faded_color)
