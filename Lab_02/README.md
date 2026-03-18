# Lab 02 – Rój obcych i Hive Mind

## Co zostało zrealizowane

Zaimplementowano system zarządzania rojem obcych generowanym z mapy tekstowej. Układ przeciwników definiowany jest tablicą stringów w `init()`, a algorytm spawning'u przelicza kolumny i rzędy na pozycje ekranowe, dbając o wyśrodkowanie całej formacji. Narysowano 3 różne sprite'y przeciwników.

Ruch roju oparty jest na zmiennych globalnych `swarm_direction` i `move_interval` — obcy poruszają się skokowo co określoną liczbę klatek, nie płynnie. Hive Mind działa poprawnie: przed każdym krokiem sprawdzane są pozycje skrajnych obcych, a dopiero potem cały rój zmienia kierunek i opada w dół — żaden obcy nie wyłamuje się z szyku.

Dodano animację klatkową — każdy typ obcego posiada conajmniej dwie klatki animacji. Zaimplementowano Panic Mode: interwał między krokami skraca się wraz ze zmniejszaniem się liczby pozostałych przeciwników, co stopniowo przyspiesza rój i buduje napięcie.

## Uruchomienie

1. Wejdź na [microstudio.dev](https://microstudio.io/i/JakubR/tgk01_jakubrudnicki/)
2. Kliknij **Run** — działa bezpośrednio w przeglądarce, bez instalacji

## Trudności / refleksja

Najtrudniejsza okazała się kolejność operacji w logice Hive Mind — sprawdzenie kolizji ze ścianą musi nastąpić *przed* przesunięciem roju, nie po.
