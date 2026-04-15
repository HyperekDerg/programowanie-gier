import math
import pyray as rl
from config import (
    THRUST,
    FRICTION,
    ROTSPEED,
    MAXSPEED,
    VERTS,
    FLAME_VERTS,
    SHIP_SIZE,
    COLOR_SHIP,
    COLOR_FLAME,
    COLOR_DEBUG,
    BRAKE_FACTOR,
)
from utils import SCREEN_W, SCREEN_H, ghost_positions, rotate_point

DEBUG = False


class Ship:
    def __init__(self, start_x: float, start_y: float):
        self.x = float(start_x)
        self.y = float(start_y)
        self.angle = 0.0
        self.velocity_x = 0.0
        self.velocity_y = 0.0
        self._is_thrusting = False

    def update(self, delta_time: float) -> None:
        self._is_thrusting = False
        self._handle_rotation(delta_time)
        self._handle_thrust(delta_time)
        self._handle_brake(delta_time)
        self._apply_friction(delta_time)
        self._clamp_speed()
        self._move(delta_time)

    def wrap(self) -> None:
        self.x %= SCREEN_W
        self.y %= SCREEN_H

    def _handle_rotation(self, delta_time: float) -> None:
        if rl.is_key_down(rl.KeyboardKey.KEY_LEFT):
            self.angle -= ROTSPEED * delta_time
        if rl.is_key_down(rl.KeyboardKey.KEY_RIGHT):
            self.angle += ROTSPEED * delta_time

    def _handle_thrust(self, delta_time: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_UP):
            return

        self._is_thrusting = True
        direction_x = math.sin(self.angle)
        direction_y = -math.cos(self.angle)

        self.velocity_x += direction_x * THRUST * delta_time
        self.velocity_y += direction_y * THRUST * delta_time

    def _handle_brake(self, delta_time: float) -> None:
        if not rl.is_key_down(rl.KeyboardKey.KEY_Z):
            return
        reduction = max(0.0, 1.0 - BRAKE_FACTOR * delta_time)
        self.velocity_x *= reduction
        self.velocity_y *= reduction

    def _apply_friction(self, delta_time: float) -> None:
        current_speed = math.hypot(self.velocity_x, self.velocity_y)
        if current_speed > 0:
            friction_force = min(FRICTION * delta_time, current_speed)
            self.velocity_x -= (self.velocity_x / current_speed) * friction_force
            self.velocity_y -= (self.velocity_y / current_speed) * friction_force

    def _clamp_speed(self) -> None:
        current_speed = math.hypot(self.velocity_x, self.velocity_y)
        if current_speed > MAXSPEED:
            ratio = MAXSPEED / current_speed
            self.velocity_x *= ratio
            self.velocity_y *= ratio

    def _move(self, delta_time: float) -> None:
        self.x += self.velocity_x * delta_time
        self.y += self.velocity_y * delta_time

    def draw(self) -> None:
        for ghost_x, ghost_y in ghost_positions(self.x, self.y, SHIP_SIZE):
            self._draw_at(ghost_x, ghost_y)

    def _draw_at(self, center_x: float, center_y: float) -> None:
        if self._is_thrusting:
            self._draw_flame_at(center_x, center_y)
        self._draw_hull_at(center_x, center_y)
        if DEBUG:
            self._draw_debug_at(center_x, center_y)

    def _draw_flame_at(self, cx: float, cy: float) -> None:
        flame_color = rl.Color(*COLOR_FLAME)
        world_verts = self._get_world_verts(FLAME_VERTS, cx, cy)
        rl.draw_triangle_lines(
            rl.Vector2(*world_verts[0]),
            rl.Vector2(*world_verts[1]),
            rl.Vector2(*world_verts[2]),
            flame_color,
        )

    def _draw_hull_at(self, cx: float, cy: float) -> None:
        hull_color = rl.Color(*COLOR_SHIP)
        world_verts = self._get_world_verts(VERTS, cx, cy)
        rl.draw_triangle_lines(
            rl.Vector2(*world_verts[0]),
            rl.Vector2(*world_verts[1]),
            rl.Vector2(*world_verts[2]),
            hull_color,
        )

    def _get_world_verts(self, local_verts: list, cx: float, cy: float) -> list:
        return [
            (cx + rx, cy + ry)
            for rx, ry in [rotate_point(lx, ly, self.angle) for lx, ly in local_verts]
        ]

    def _draw_debug_at(self, cx: float, cy: float) -> None:
        debug_color = rl.Color(*COLOR_DEBUG)
        current_speed = math.hypot(self.velocity_x, self.velocity_y)
        scale = 0.3
        rl.draw_line(
            int(cx),
            int(cy),
            int(cx + self.velocity_x * scale),
            int(cy + self.velocity_y * scale),
            debug_color,
        )
        rl.draw_text(
            f"speed: {current_speed:.1f}", int(cx) + 15, int(cy) - 10, 14, debug_color
        )
