# Lab 04 – Maszyna stanów i kompletna pętla gry

## Co zostało zrealizowane

Zaimplementowano Finite State Machine opartą na delegatach funkcji — zmienne `current_update` i `current_draw` wskazują na aktywne funkcje logiki i rysowania, eliminując rozbudowane bloki `if/else` dla stanów. Gra przeprowadza gracza przez pełny cykl: Menu → Rozgrywka → Wygrana/Porażka → Restart, bez konieczności odświeżania strony.

Wydzielono funkcję `reset_game()`, która przy każdym restarcie czyści stan gry — pozycję gracza, tablice pocisków, wrogów i cząsteczek oraz wynik — dzięki czemu ponowne uruchomienie jest zawsze deterministyczne. Napisano ekrany końcowe z wyświetleniem wyniku, rangi gracza i instrukcją powrotu. Dodano funkcję `drawUI()` rysowaną jako ostatnia warstwa — wyświetla aktualny wynik oraz stan żyć gracza.

Zaimplementowano trwały zapis najwyższego wyniku przy użyciu `storage.set` / `storage.get`. High Score jest wczytywany przy starcie, aktualizowany w momencie przegranej lub wygranej i wyświetlany w menu głównym.

## Uruchomienie

1. Wejdź na [microstudio.dev](https://microstudio.io/i/JakubR/tgk01_jakubrudnicki/)
2. Kliknij **Run** — działa bezpośrednio w przeglądarce, bez instalacji
