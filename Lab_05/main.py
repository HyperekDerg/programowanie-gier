import pyray as rl
from ship import Ship

SCREEN_W = 800
SCREEN_H = 600
TARGET_FPS = 60


def main():
    rl.init_window(SCREEN_W, SCREEN_H, "Lab 05 – Jakub Rudnicki")
    rl.set_target_fps(TARGET_FPS)

    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        ship.update(dt)

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        ship.draw()

        rl.draw_text("Move with Arrow Keys | Z Brake", 10, 10, 16, rl.LIGHTGRAY)
        rl.draw_text(f"FPS: {rl.get_fps()}", SCREEN_W - 80, 10, 16, rl.GREEN)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()
