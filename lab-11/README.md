# Laboratorium 11

## Opis

Laboratorium polegało na rozbudowie projektu gry o system przeciwników, pocisków i fal spawnu. Wykonano wszystkie polecenia opisane w instrukcji.

## Zrealizowane zadania

### Scena przeciwnika
Utworzono nową scenę `enemy`, do której przypisano prosty model przeciwników. Wszystkie warstwy kolizji zostały ustawione zgodnie z zaleceniami instrukcji.

### Skrypty
Napisano nowe skrypty oraz zmodyfikowano istniejące w celu poprawy czytelności kodu. Skorzystano z zewnętrznego formattera, który automatycznie wykonuje reorder funkcji.

### Ruch przeciwników
Przeciwnicy poruszają się z wykorzystaniem **Tween** oraz **Z distance** — nacierają na gracza i zawracają aż do ustalonej odległości, po czym są usuwani ze sceny.

### Wspólna scena pocisku
Zarówno gracz, jak i przeciwnicy korzystają z jednej wspólnej sceny `bullet`. Scena przyjmuje parametr określający typ rodzica:
- `player` — pocisk gracza
- `enemy` — pocisk przeciwnika

Na podstawie tego parametru w skrypcie `bullet` przypisywane są odpowiednie warstwy kolizji.

### Spawner fal
Spawner fal działa zgodnie z założonym wzorcem. Przeciwnicy nie dążą do identycznego punktu startowego — ich pozycje są zróżnicowane.

### Mechaniki walki
- Gracz może strzelać oraz taranować przeciwników.
- Przeciwnicy mogą strzelać
