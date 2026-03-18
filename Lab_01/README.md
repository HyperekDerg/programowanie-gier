# Lab 01 – Setup, ruch i sprite gracza

## Co zostało zrealizowane

Skonfigurowano środowisko w microStudio i utworzono publiczny projekt. Kod podzielono rygorystycznie na trzy funkcje: `init()` przechowuje zmienne pozycji i rozmiaru gracza, `update()` obsługuje sterowanie klawiaturą oraz clamping, a `draw()` odpowiada wyłącznie za rysowanie sprite'a.
Narysowano własny sprite statku kosmicznego 22x26.
Zaimplementowano ograniczenie ruchu do granic ekranu — statek nie wyjeżdża poza krawędzie.

## Uruchomienie

1. Wejdź na [microstudio.dev](https://microstudio.io/i/JakubR/tgk01_jakubrudnicki/)
2. Kliknij **Run** — działa bezpośrednio w przeglądarce, bez instalacji

## Trudności / refleksja

Układ współrzędnych w microStudio (środek ekranu jako `0,0`) wymaga chwili przyzwyczajenia w porównaniu do klasycznych układów 2D. Clamping okazał się prostszy niż się wydawało — wystarczyły cztery warunki w `update()`.
