# Lab 08 – Projekt: Asteroids

## FSM, Podział Asteroid i Domknięcie Projektu

### Zrealizowane funkcjonalności

- trzypoziomowy podział asteroid – Asteroid przyjmuje level (1–3), który wyznacza rozmiar i prędkość; - metoda split() zwraca dwie mniejsze asteroidy lub pustą listę dla poziomu 1,
- maszyna stanów (FSM) z trzema stanami MENU, GAME, GAME_OVER opartymi na enum.Enum; każdy stan ma osobne funkcje update_* i draw_*,
- system punktacji – zmienne score i best; mniejsze asteroidy dają więcej punktów; draw_hud() wyświetla wynik w rogu ekranu,
- warunki końca gry: śmierć przez kolizję statku z asteroidą oraz zwycięstwo po zniszczeniu wszystkich asteroid (końcowo zmieniono na fale bez końca, jednak w historii commitów znajduje się ta zmiana),
- refaktoryzacja: magic numbers przeniesione do config.py, powtórzony kod filtrowania list wydzielony do utils.py, opisowe nazwy zmiennych.
### Zadanie Dodatkowe: Kolizja Statek–Asteroida

- fale asteroid – po zniszczeniu wszystkich pojawia się nowa, trudniejsza fala; numer fali widoczny na HUD, wynik nie jest resetowany,

### Uruchomienie

1. Skopiuj katalog z kodem `lab_08`.
2. Upewnij się, że posiadasz środowisko z Pythonem oraz zainstalowaną bibliotekę raylib (moduł `pyray`) oraz standardowe biblioteki `math` i `random`.
3. Uruchom projekt z poziomu IDE lub wykonaj w katalogu `lab_08` polecenie:

```bash
python main.py
```

### Sterowanie

| Klawisz              | Akcja        |
| -------------------- | ------------ |
| `←` / `→`            | Obrót statku |
| `↑`                  | Ciąg silnika |
| `Z`                  | Hamowanie    |
| `SPACEBAR`           | Strzał       |
| `R`                  | Restart      |
| `Enter` / `SPACEBAR` | Start gr     |

