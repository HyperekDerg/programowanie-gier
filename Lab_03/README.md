# Lab 03 – Kolizje, strzelanie i Frontline AI

## Co zostało zrealizowane

Przekształcono symulację w pełnoprawną grę z mechaniką strzelania i detekcją kolizji. Gracz strzela pociskami (limit 2 jednocześnie), a trafienie niszczy przeciwnika i przyznaje punkty. Zaimplementowano funkcję `overlap()` opartą na AABB oraz mechanizm Mark & Sweep do bezpiecznego usuwania martwych obiektów z list — zarówno pocisków gracza, pocisków wroga, jak i samych przeciwników.

Przeciwnicy strzelają według logiki Frontline: funkcja `findFrontline()` wyłania obcych z najniższej pozycji w każdej kolumnie, spośród których losowo wybierany jest strzelec. Trafienie gracza odbiera życie, a utrata wszystkich kończy grę ekranem Game Over.

Dodano bunkry z systemem uszkodzeń — każdy bunkier ma punkty życia i zmienia sprite w zależności od stopnia zniszczenia, a pociski obu stron go uszkadzają. Zaimplementowano system cząsteczek: eksplozje generują kilkanaście kwadracików z losową prędkością i czasem życia, które wyraźnie podnoszą dynamikę wizualną.

Kod został dodatkowo zrefaktoryzowany — logika podzielona na wyspecjalizowane funkcje (`updateBullets`, `updateEnemyBullets`, `enemyFire`, `updateParticles`, `cleanup`, `drawUI` itp.), co poprawia czytelność i ułatwia dalszy rozwój projektu.

## Uruchomienie

1. Wejdź na [microstudio.dev](https://microstudio.io/i/JakubR/tgk01_jakubrudnicki/)
3. Kliknij **Run** — działa bezpośrednio w przeglądarce, bez instalacji

## Trudności / refleksja

Najtrudniejszy okazał się algorytm `findFrontline()` — znalezienie najniższego obcego w każdej kolumnie wymaga porównania pozycji Y wszystkich obcych o tym samym X, co przy dynamicznie kurczącym się roju łatwo zepsuć. Refaktoryzacja kodu na mniejsze funkcje znacznie ułatwiła debugowanie i sprawiła, że główna pętla `update()` stała się czytelna.
