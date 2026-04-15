import pyray as rl
import math
from enum import Enum, auto
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
    generate_random_asteroid,
    cleanup_dead_entities,
)
from config import (
    TARGET_FPS,
    SHIP_SIZE,
    MAX_BULLETS,
    NUMBER_OF_ASTEROIDS,
    POINTS_MAP,
    SHIP_COLLISION_RADIUS_RATIO,
    SHIP_EXPLOSION_SCALE,
    ASTEROID_EXPLOSION_SCALE,
    HUD_FONT_SIZE_LARGE,
    HUD_FONT_SIZE_SMALL,
)


class State(Enum):
    MENU = auto()
    GAME = auto()
    GAME_OVER = auto()


# --- STAN GLOBALNY ---
current_state = State.MENU
score = 0
best = 0
victory = False

ship = None
bullets = []
asteroids = []
explosions = []
background = None
sound_shoot = None
sound_explosion = None


def init_game():
    global ship, bullets, asteroids, explosions, score, victory
    score = 0
    victory = False
    ship = Ship(SCREEN_W / 2, SCREEN_H / 2)
    bullets.clear()
    explosions.clear()
    asteroids[:] = [
        Asteroid(*generate_random_asteroid()) for _ in range(NUMBER_OF_ASTEROIDS)
    ]


def handle_collisions():
    global score, best, current_state, victory

    # Kolizje: Pocisk Asteroida
    for bullet in bullets:
        for asteroid in asteroids:
            if (
                bullet.alive
                and asteroid.alive
                and circles_collide(
                    bullet.x,
                    bullet.y,
                    bullet.radius,
                    asteroid.x,
                    asteroid.y,
                    asteroid.radius,
                )
            ):
                bullet.alive = False
                asteroid.alive = False
                score += POINTS_MAP.get(asteroid.level, 0)
                if score > best:
                    best = score

                rl.play_sound(sound_explosion)
                explosions.append(
                    Explosion(
                        asteroid.x,
                        asteroid.y,
                        asteroid.radius * ASTEROID_EXPLOSION_SCALE,
                    )
                )
                asteroids.extend(asteroid.split())

    # Kolizje: Statek Asteroida
    for asteroid in asteroids:
        if asteroid.alive and circles_collide(
            ship.x,
            ship.y,
            SHIP_SIZE * SHIP_COLLISION_RADIUS_RATIO,
            asteroid.x,
            asteroid.y,
            asteroid.radius,
        ):
            rl.play_sound(sound_explosion)
            explosions.append(
                Explosion(ship.x, ship.y, SHIP_SIZE * SHIP_EXPLOSION_SCALE)
            )
            victory = False
            current_state = State.GAME_OVER


def update_game(dt):
    global current_state, victory

    ship.update(dt)
    ship.wrap()

    # Obsługa strzału
    if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE) and len(bullets) < MAX_BULLETS:
        nose_x, nose_y = rotate_point(0, -15, ship.angle)
        bullets.append(Bullet(ship.x + nose_x, ship.y + nose_y, ship.angle))
        rl.play_sound(sound_shoot)

    # Aktualizacja obiektów
    for entity in bullets + asteroids + explosions:
        entity.update(dt)

    handle_collisions()

    # Czyszczenie nieaktywnych obiektów
    cleanup_dead_entities(bullets)
    cleanup_dead_entities(asteroids)
    cleanup_dead_entities(explosions)

    # Warunek Zwycięstwa
    if not asteroids and current_state == State.GAME:
        victory = True
        current_state = State.GAME_OVER


def draw_hud():
    rl.draw_text(f"SCORE: {score}", 20, 20, HUD_FONT_SIZE_LARGE, rl.RAYWHITE)
    rl.draw_text(f"BEST:  {best}", 20, 50, HUD_FONT_SIZE_SMALL, rl.GOLD)
    rl.draw_text(f"FPS: {rl.get_fps()}", SCREEN_W - 80, 20, 16, rl.GREEN)


def draw_menu():
    rl.draw_texture(background, 0, 0, rl.WHITE)
    title = "ASTEROIDS"
    hint = "Press SPACE or ENTER to Start"

    rl.draw_text(
        title,
        SCREEN_W // 2 - rl.measure_text(title, 60) // 2,
        SCREEN_H // 2 - 50,
        60,
        rl.RAYWHITE,
    )
    rl.draw_text(
        hint,
        SCREEN_W // 2 - rl.measure_text(hint, 20) // 2,
        SCREEN_H // 2 + 20,
        20,
        rl.GRAY,
    )


def draw_game_over():
    rl.draw_texture(background, 0, 0, rl.WHITE)

    title = "MISSION ACCOMPLISHED!" if victory else "GAME OVER"
    title_color = rl.GOLD if victory else rl.RED

    rl.draw_text(
        title,
        SCREEN_W // 2 - rl.measure_text(title, 40) // 2,
        SCREEN_H // 2 - 80,
        40,
        title_color,
    )
    rl.draw_text(
        f"Final Score: {score}",
        SCREEN_W // 2 - rl.measure_text(f"Final Score: {score}", 30) // 2,
        SCREEN_H // 2,
        30,
        rl.RAYWHITE,
    )
    rl.draw_text(
        "Press [R] to return to Menu",
        SCREEN_W // 2 - rl.measure_text("Press [R] to return to Menu", 20) // 2,
        SCREEN_H // 2 + 70,
        20,
        rl.GRAY,
    )


def main():
    global background, sound_shoot, sound_explosion, current_state

    rl.init_window(SCREEN_W, SCREEN_H, "Asteroids – Jakub Rudnicki")
    rl.set_target_fps(TARGET_FPS)
    rl.init_audio_device()

    # Ładowanie zasobów
    sound_shoot = rl.load_sound(SOUND_SHOOTING)
    sound_explosion = rl.load_sound(SOUND_EXPLOSION)
    background = rl.load_texture(BACKGROUND_TEXTURE)

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        # Maszyna Stanów Logika
        if current_state == State.MENU:
            if rl.is_key_pressed(rl.KeyboardKey.KEY_ENTER) or rl.is_key_pressed(
                rl.KeyboardKey.KEY_SPACE
            ):
                init_game()
                current_state = State.GAME

        elif current_state == State.GAME:
            update_game(dt)

        elif current_state == State.GAME_OVER:
            if rl.is_key_pressed(rl.KeyboardKey.KEY_R):
                current_state = State.MENU

        # Maszyna Stanów Rysowanie
        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        if current_state == State.MENU:
            draw_menu()
        elif current_state == State.GAME:
            rl.draw_texture(background, 0, 0, rl.WHITE)
            for entity in explosions + bullets + asteroids:
                entity.draw()
            ship.draw()
            draw_hud()
        elif current_state == State.GAME_OVER:
            draw_game_over()

        rl.end_drawing()

    # Czyszczenie pamięci
    rl.unload_sound(sound_shoot)
    rl.unload_sound(sound_explosion)
    rl.unload_texture(background)
    rl.close_audio_device()
    rl.close_window()


if __name__ == "__main__":
    main()
