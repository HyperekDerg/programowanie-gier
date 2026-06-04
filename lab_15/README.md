# [Noir Saur]

> Demo gry platformowej 2D osadzonej w mrocznym świecie gdzie grasz jako dinozaur przemierzający niebezpieczne poziomy.

---

## Opis gry

Gra jest grą 2D zbudowaną na silniku Godot 4.x. Gra jest platformówką 2D w mrocznym klimacie. Grasz jako dinozaur, który poszukuje przejścia dalej. Na drodze stoją niebezpieczeństwa w postaci przeciwników, przepaści oraz terenu. Jest to grywalne demo skupiające się na przedstawieniu klimatu oraz mechanik.

### Jak się gra?

- **Cel:** Dotrzyj do końca poziomu

- **Sterowanie:**
  | Klawisz / akcja | Działanie |
  |-----------------|-----------|
  | `←` / `→` | Ruch postaci (chód) |
  | `Shift` + `←` / `→` | Bieg |
  | `↓` | Kucanie (zmniejsza prędkość i hitbox) |
  | `Spacja` | Skok |
  | `Esc` (przytrzymaj) | Powrót do menu głównego |

---

## Silnik i technologia

- **Silnik:** Godot 4.x
- **Język:** GDScript
- **Wymiar:** 2D

### Uruchomienie projektu

```bash
# 1. Sklonuj repozytorium
git clone git@github.com:HyperekDerg/programowanie-gier.git
cd programowanie-gier/lab_15

# 2. Otwórz projekt w Godot 4.x
#    File → Open Project → wskaż folder lab_15

# 3. Naciśnij F5 lub przycisk ▶ aby uruchomić
```

---

## Własny mechanizm

### System pochodni z przestrzennym audio i flickerem

Każda pochodnia w poziomie posiada własny dynamiczny efekt migotania oparty na **Simplex Smooth Noise** (klasa `torch.gd`). Jasność światła (`PointLight2D`) jest na bieżąco modyfikowana szumem perlinowskim z losowym jitterem, co daje organiczny, nieregularny efekt płomienia.

Dźwięk pochodni obsługuje globalny singleton `TorchAudioManager` — zamiast osobnego playera per pochodnia, jeden współdzielony `AudioStreamPlayer2D` jest dynamicznie przesuwany do najbliższej pochodni względem kamery. Głośność i pitch są modulowane tym samym szumem co światło, synchronizując efekt wizualny z dźwiękowym. Pochodnie niewidoczne na ekranie są automatycznie dezaktywowane (`VisibleOnScreenNotifier2D`), co optymalizuje wydajność.

**Uzasadnienie:** Mechanizm wzbogaca klimat mrocznego świata gry o żywy, oddychający ambient bez żadnego narzutu na CPU dla obiektów poza ekranem. Zsynchronizowanie flickera świetlnego z audio daje spójne doświadczenie sensoryczne niemożliwe do osiągnięcia prostym zapętlonym dźwiękiem.

---

## Czy projekt jest klonem?

- [X] Nie — oryginalny pomysł

---

## Wykorzystane zasoby

### Muzyka i dźwięki

| Plik | Opis | Autor / źródło |
|------|------|----------------|
| `assets/sounds/jump.mp3` | Dźwięk skoku gracza | plasterbrain @ [freesound.org](https://freesound.org/people/plasterbrain/sounds/399095/) |
| `assets/sounds/magic-coins.mp3` | Dźwięk zebrania monety | [myinstants.com](https://www.myinstants.com/en/instant/magic-coins-97911/) |
| `assets/sounds/sonicded.mp3` | Dźwięk śmierci gracza | [myinstants.com](https://www.myinstants.com/en/instant/sonic-death-sound-93243/) |
| `assets/sounds/walk.mp3` | Dźwięk chodzenia gracza | [myinstants.com](https://www.myinstants.com/en/instant/blitz-walk-70107/) |
| `assets/bgm/StockTune-Creepy Whispers In Shadows_1778079680.mp3` | Muzyka w tle (gameplay) | [stocktune.com — Creepy Whispers in Shadows](https://stocktune.com/free-music/creepy-whispers-in-shadows-212525-131058) |
| `assets/sounds/torch.wav` | Dźwięk ambient pochodni | freepixel.art — [sfx-ambient_loops-campfire](https://freepixel.art/audio/asset/sfx-ambient_loops-campfire) |
| `assets/bgm/StockTune-Dark Shadows Lurking_1778500648.mp3` | Muzyka menu głównego | [stocktune.com — Dark Shadows Lurking](https://stocktune.com/free-music/dark-shadows-lurking-5609-19912) |
| `assets/sounds/hover.wav` | Dźwięk najechania na przycisk | vacuumfan7072 @ [freesound.org](https://freesound.org/people/vacuumfan7072/sounds/265767/) |
| `assets/sounds/Press.wav` | Dźwięk kliknięcia przycisku | MATUSTRM @ [freesound.org](https://freesound.org/people/MATUSTRM/sounds/836201/) |

### Grafika i sprite'y

| Plik / folder | Opis | Autor / źródło  |
|---------------|------|----------------
| `assets/sprites/player.png` | Sprite gracza (dinozaur) | [@ArksDigital](https://arks.itch.io/dino-characters)|
| `assets/tiles` | Tile mapa | [@KenneyNL](https://kenney-assets.itch.io/1-bit-platformer-pack)|

### Czcionki

| Plik | Opis | Autor / źródło |
|------|------|----------------|
| `assets/fonts/*.ttf` | Czcionki UI i menu | [Google Fonts](https://fonts.google.com/) |

---

## Mechaniki techniczne

- **Maszyna stanów (FSM):**
  - *Gracz* (`player.gd`): stany animacji — `Idle`, `Walk`, `Run`, `Jump`, `Crouch`, `Death`; zarządzanie flagi `dead` / `level_complete`.
  - *Przeciwnik* (`enemy.gd`): trzy stany — `WANDERING` (patrol między punktami), `ATTACKER` (atak z charge_speed po wykryciu gracza), `SEARCHING` (szukanie gracza po utracie kontaktu, z losowym obracaniem).
- **Kolizje:**
  - Detekcja wzroku przeciwnika: `RayCast2D` + sprawdzenie grupy `"player"`.
  - Gracz używa dwóch `CollisionShape2D` (stojąca / kucająca), przełączanych dynamicznie przez `set_deferred`.
  - `KillZone` i `LevelComplete` jako `Area2D` reagujące na wejście gracza.
- **System monet:** Singleton `CoinManager` emituje sygnał `coin_collected(total)` — HUD nasłuchuje i aktualizuje licznik w czasie rzeczywistym.
- **ESC / powrót do menu:** Przytrzymanie `Esc` przez 1,5 s uruchamia przejście; postęp wizualizowany animowanym łukiem z efektem glitch (`game.gd`).
- **Menu główne:** ✅ Fade-in/out, efekt flickera światła punktowego, animacja przycisku hover (skala + jasność), migający kursor `▶`, idle-pulse gdy brak interakcji.
- **Ekran końca gry:** ✅ Ukończenie poziomu (wygrana) — `LevelComplete` ładuje następną scenę; śmierć (przegrana) — `KillZone` przeładowuje scenę z efektem slow-motion (`Engine.time_scale = 0.5`).
- **Dźwięk / muzyka:** ✅ Oddzielne busey audio: `BGM` (muzyka) i `SFX` (efekty). Fade-out muzyki przy zmianie sceny.

---

## Znane bugi i ograniczenia

- [ ] Bieg gracza jest nieprawidłowy w przypadku biegu po rurach.
- [ ] AI wrogów nie reaguje na krawędzie platform (może spaść).

---

## Autor

**Jakub Rudnicki** — 89213
