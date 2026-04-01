# Lab 06 – Projekt: Asteroids
## Topologia Świata i Asteroidy
### Zrealizowane funkcjonalności

W ramach laboratorium rozbudowano projekt o pliki `main.py`, `ship.py`, `asteroid.py` oraz `utils.py`, zachowując okno gry o rozdzielczości 800×600 px. W projekcie zaimplementowano:

- zawijanie pozycji statku przez wszystkie cztery krawędzie ekranu za pomocą operacji modulo,
- klasę `Asteroid` z losowym wektorem prędkości zależnym od promienia (większe asteroidy poruszają się wolniej),
- ruch asteroid z poprawnym zastosowaniem delta time oraz metodą `wrap()` spójną interfejsowo z klasą `Ship`,
- ghost rendering – renderowanie widm obiektów przy krawędziach ekranu, dzięki czemu obiekt jest widoczny jednocześnie po obu stronach podczas przejścia,
- wspólną funkcję `ghost_positions(x, y, size)` w pliku `utils.py` zwracającą od 1 do 4 pozycji rysowania w zależności od położenia obiektu,
- przeniesienie stałych `SCREEN_W` i `SCREEN_H` do `utils.py` – żaden inny plik nie definiuje tych wartości osobno,
- proceduralne generowanie nieregularnych kształtów asteroid: N=9 wierzchołków z losowym przesunięciem promienia w zakresie ±35%,
- losową prędkość kątową (`rot_speed`) każdej asteroidy oraz rotację wierzchołków w `draw()` z użyciem tej samej funkcji `rotate_point` co w klasie `Ship`.

### Zadanie Dodatkowe: Separacja Konfiguracji

Zrealizowano zadanie dodatkowe – wszystkie stałe liczbowe projektu zostały przeniesione do pliku `config.py`. Obejmuje to parametry statku (`THRUST`, `FRICTION`, `ROTSPEED`, `MAXSPEED`) oraz parametry asteroid (`NUM_VERTS`, `RADIUS_JITTER`, zakres prędkości kątowej). Zmiana charakteru rozgrywki sprowadza się do edycji jednego pliku, bez ingerencji w logikę gry.

### Uruchomienie

1. Skopiuj katalog z kodem `lab_06`.
2. Upewnij się, że posiadasz środowisko z Pythonem oraz zainstalowaną bibliotekę raylib (moduł `pyray`) oraz standardowe biblioteki `math` i `random`.
3. Uruchom projekt z poziomu IDE lub wykonaj w katalogu `lab_06` polecenie:

```bash
python main.py
```

### Sterowanie

| Klawisz | Akcja |
|---|---|
| `←` / `→` | Obrót statku |
| `↑` | Ciąg silnika |
| `Z` | Hamowanie |
