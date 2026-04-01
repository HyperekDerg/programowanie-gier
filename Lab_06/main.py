import pyray as rl
from ship import Ship
from asteroid import Asteroid
from utils import SCREEN_W, SCREEN_H

TARGET_FPS = 60

ASTEROIDS = [
    Asteroid(200, 150, 45),
    Asteroid(600, 400, 30),
    Asteroid(400, 300, 20),
    Asteroid(100, 500, 55),
    Asteroid(700, 100, 25),
]


def main():
    rl.init_window(SCREEN_W, SCREEN_H, "Lab 05 – Jakub Rudnicki")
    rl.set_target_fps(TARGET_FPS)

    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        ship.update(dt)
        ship.wrap()

        for asteroid in ASTEROIDS:
            asteroid.update(dt)

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        for asteroid in ASTEROIDS:
            asteroid.draw()

        ship.draw()

        rl.draw_text("Move: Arrow Keys | Brake: Z", 10, 10, 16, rl.LIGHTGRAY)
        rl.draw_text(f"FPS: {rl.get_fps()}", SCREEN_W - 80, 10, 16, rl.GREEN)
        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()
