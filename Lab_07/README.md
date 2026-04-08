# Lab 07 – Projekt: Asteroids

## Pociski, Zasoby i Kolizje

### Zrealizowane funkcjonalności

W ramach laboratorium rozbudowano projekt o pliki `bullet.py`, `explosion.py` oraz katalog `assets`. Zrealizowano następujące elementy:

- klasę pocisku poruszającego się z prędkością zależną od kąta statku w chwili strzału, z ograniczeniem do 4 pocisków jednocześnie na ekranie,
- mechanizm TTL (Time-To-Live) – pocisk automatycznie znika po upływie zadanego czasu; nieaktywne pociski usuwane są przez list comprehension,
- strzelanie wywoływane przez `iskeypressed` – rejestruje pojedyncze naciśnięcie klawisza, w odróżnieniu od `iskeydown` reagującego na przytrzymanie,
- obsługę dźwięku – inicjalizacja urządzenia audio, załadowanie plików dźwiękowych oraz poprawne zwolnienie zasobów po wyjściu z pętli głównej (kolejność zwalniania ma znaczenie),
- proceduralne tło gwiazd – jednorazowo generowana lista losowych pozycji punktów rysowanych co klatkę jako pierwsze (zarządzanie kolejnością warstw),
- funkcję `circle_collision(x1, y1, r1, x2, y2, r2)` w `utils.py` sprawdzającą kolizję dwóch okręgów na podstawie `math.hypot`,
- kolizję pocisk–asteroida: oznaczanie obiektów jako nieaktywne w fazie sprawdzania, czyszczenie list w osobnej fazie przez list comprehension – zapobiega modyfikacji listy podczas iteracji,
- klasę `Explosion` w `explosion.py` – animacja okręgu konturowego o rosnącym promieniu, zarządzana listą analogicznie do pocisków.

### Zadanie Dodatkowe: Kolizja Statek–Asteroida

Zrealizowano oba zadania dodatkowe – wykrywanie kolizji statku z asteroidą. Statek traktowany jest jako koło o stałym promieniu. Przy zderzeniu tworzona jest eksplozja, a pozycja statku oraz jego prędkość są resetowane do wartości początkowych (centrum ekranu, wektor zerowy). Gra nie kończy się – gracz może kontynuować rozgrywkę. A także jak wspomniano wcześniej ograniczo o liczbę pocisków do 4.

### Uruchomienie

1. Skopiuj katalog z kodem `lab_07`.
2. Upewnij się, że posiadasz środowisko z Pythonem oraz zainstalowaną bibliotekę raylib (moduł `pyray`) oraz standardowe biblioteki `math` i `random`.
3. Uruchom projekt z poziomu IDE lub wykonaj w katalogu `lab_07` polecenie:

```bash
python main.py
```

### Sterowanie

| Klawisz    | Akcja        |
| ---------- | ------------ |
| `←` / `→`  | Obrót statku |
| `↑`        | Ciąg silnika |
| `Z`        | Hamowanie    |
| `SPACEBAR` | Strzał       |
