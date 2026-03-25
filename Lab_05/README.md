# Lab 05 – Projekt: Asteroids
## Statek – Geometria, Ruch i Fizyka
### Zrealizowane funkcjonalności

W ramach laboratorium przygotowano pliki main.py oraz ship.py, które umożliwiają uruchomienie gry w oknie o rozdzielczości 800×600 px. W projekcie zaimplementowano:

- narysowanie statku kosmicznego zdefiniowanego za pomocą wierzchołków,
- podstawową fizykę ruchu: tarcie, ograniczenie prędkości, obsługę wektora prędkości,
- generowanie płomienia podczas przyspieszania statku,
- odbijanie statku od krawędzi ekranu,
- wyświetlanie FPS oraz prostą instrukcję sterowania,
- tryb debugowania prezentujący kierunek wektora prędkości oraz aktualną prędkość,
- podział kodu statku na funkcje i metody, co ułatwia dalszą rozbudowę i modyfikację gry.

Dodatkowo upewniono się, że zastosowanie dt działa poprawnie przy różnych ustawieniach FPS:
- 30
- 60
- 120

### Uruchomienie

1. Skopiuj katalog z kodem lab_05.
2. Upewnij się, że posiadasz środowisko z Pythonem oraz zainstalowaną bibliotekę raylib (moduł raylibpy) oraz standardową bibliotekę math.
3. Uruchom projekt z poziomu IDE lub wykonaj w katalogu lab_05 polecenie:

    ```bash
    python main.py
    ```