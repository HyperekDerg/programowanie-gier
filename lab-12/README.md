# Laboratorium 12

## Opis

Laboratorium polegało na rozbudowie projektu gry o elementy budujące atmosferę i odczucie sterowania (game feel): tło sceny 3D, kolizję gracza ze ścianami korytarza, opóźnioną kamerę śledzącą statek oraz barrel roll jako ruch obronny z flagą nieśmiertelności. Wykonano wszystkie polecenia opisane w instrukcji.

## Zrealizowane zadania

### Tło sceny
Dodano węzeł WorldEnvironment z zasobem Environment. Ustawiono tło na Sky z ProceduralSkyMaterial w ciemnych barwach z efektem zachodzącego słońca.
### Korytarz ze ścianami
Dodano dwie ściany jako StaticBody3D (z MeshInstance3D i CollisionShape3D) symetrycznie po obu stronach trasy. Dodano mechanizm kolizji statku z ścianami.
### Kamera z opóźnieniem
Wydzielono CameraTarget (pusty Node3D) jako dziecko PathFollow3D w miejscu, gdzie wcześniej znajdowała się kamera. Camera3D przeniesiono poza PathFollow3D jako dziecko głównego Node3D. Na Camera3D napisano skrypt, który z opóźnieniem ustawia kamerę.
### Barrel Roll
Dodano AnimationPlayer jako dziecko węzła Mesh. Utworzono animację barrel_roll o czasie trwania 0.6 s ze ścieżką rotation:z i kluczami 0.0 → TAU. W skrypcie statku zaimplementowano:

- flagę is_invincible: bool,
- metodę _barrel_roll() uruchamianą na klawisz *Z* — ustawia flagę, odtwarza animację, czeka na await anim_player.animation_finished, po czym zdejmuje flagę,
- blokadę na początku _take_damage: if is_invincible: return.

Zweryfikowano eksperymentalnie, że wlecenie w ścianę podczas barrel roll nie zmienia hp.
