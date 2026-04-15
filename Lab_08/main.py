import pyray as rl
from ship import Ship, rotate_point
from asteroid import Asteroid
from bullet import Bullet
from explosion import Explosion
from utils import (
    SCREEN_W,
    SCREEN_H,
    SOUND_SHOOTING,
    SOUND_EXPLOSION,
    BACKGROUND_TEXTURE,
    circles_collide,
    generate_random_asteroid
)
from config import TARGET_FPS, SHIP_SIZE, MAX_BULLETS, NUMBER_OF_ASTEROIDS


def main():
    rl.init_window(SCREEN_W, SCREEN_H, "Lab 05 – Jakub Rudnicki")
    rl.set_target_fps(TARGET_FPS)
    rl.init_audio_device()

    sound_shoot = rl.load_sound(SOUND_SHOOTING)
    sound_explosion = rl.load_sound(SOUND_EXPLOSION)
    background = rl.load_texture(BACKGROUND_TEXTURE)

    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)
    bullets = []
    explosions = []
    asteroids = [Asteroid(*generate_random_asteroid()) for _ in range(NUMBER_OF_ASTEROIDS)]

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        ship.update(dt)
        ship.wrap()

        if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE) and len(bullets) < MAX_BULLETS:
            nose_x, nose_y = rotate_point(0, -15, ship.angle)
            new_bullet = Bullet(ship.x + nose_x, ship.y + nose_y, ship.angle)
            rl.play_sound(sound_shoot)
            bullets.append(new_bullet)

        for b in bullets:
            b.update(dt)

        for asteroid in asteroids:
            asteroid.update(dt)

        for explosion in explosions:
            explosion.update(dt)

        for b in bullets:
            for a in asteroids:
                if b.alive and a.alive:
                    if circles_collide(b.x, b.y, b.radius, a.x, a.y, a.radius):
                        b.alive = False
                        a.alive = False
                        rl.play_sound(sound_explosion)
                        explosions.append(Explosion(a.x, a.y, a.radius * 2))

        for a in asteroids:
            if a.alive:
                if circles_collide(ship.x, ship.y, SHIP_SIZE * 1.2, a.x, a.y, a.radius):
                    a.alive = False
                    rl.play_sound(sound_explosion)
                    explosions.append(Explosion(ship.x, ship.y, SHIP_SIZE * 2))
                    # reset statku do środka ekranu z zerową prędkością
                    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)
                    
        for b in bullets:
            if b.alive:
                if circles_collide(ship.x, ship.y, SHIP_SIZE * 1.2, b.x, b.y, b.radius):
                    b.alive = False
                    rl.play_sound(sound_explosion)
                    explosions.append(Explosion(ship.x, ship.y, SHIP_SIZE * 2))
                    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)

        bullets = [b for b in bullets if b.alive]
        asteroids = [a for a in asteroids if a.alive]
        explosions = [e for e in explosions if e.alive]

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)
        rl.draw_texture(background, 0, 0, rl.WHITE)

        for explosion in explosions:
            explosion.draw()

        for b in bullets:
            b.draw()

        for asteroid in asteroids:
            asteroid.draw()

        ship.draw()

        rl.draw_text("Move: Arrows | Brake: Z | Shoot: Space", 10, 10, 16, rl.LIGHTGRAY)
        rl.draw_text(f"Bullets: {len(bullets)}", 10, 30, 16, rl.RAYWHITE)
        rl.draw_text(f"FPS: {rl.get_fps()}", SCREEN_W - 80, 10, 16, rl.GREEN)
        rl.end_drawing()

    rl.unload_sound(sound_shoot)
    rl.unload_sound(sound_explosion)
    rl.close_audio_device()
    rl.unload_texture(background)
    rl.close_window()


if __name__ == "__main__":
    main()
