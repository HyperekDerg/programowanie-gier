# Lab 10 – Strzelanie 3D w Godot


## Wykonane zadania

Stworzyłem osobną scenę dla pocisku jako `Area3D` z prostym modelem zastępczym. Pocisk sam się porusza do przodu i po określonym czasie usuwa się ze sceny, żeby nie zaśmiecać drzewa węzłów.

Skonfigurowałem warstwy kolizji tak, żeby pociski nie wchodziły w interakcję ze statkiem gracza ani ze sobą nawzajem — trafiają tylko w warstwę zarezerwowaną dla wrogów/celów.

Do skryptu statku dodałem logikę strzelania z cooldownem, żeby trzymanie klawisza nie generowało setek pocisków na sekundę. Pocisk jest instancjonowany i dodawany bezpośrednio do `root` sceny — nie jako dziecko `PathFollow3D`, bo wtedy leciałby razem z torem, a nie niezależnie.

Stworzyłem też scenę celu, który reaguje na wejście pocisku przez sygnał `area_entered` podłączony z kodu w `_ready()`, po czym usuwa się ze sceny. Kilka instancji rozstawiłem w `main.tscn` przed kamerą.

Na końcu dorzuciłem prostą zmienną `score` zwiększaną przy każdym trafieniu — wynik wyświetlam na warstwie graficznej jako element prostego HUD'u.

### Zadanie dodatkowe

Ograniczyłem liczbę jednocześnie aktywnych pocisków do 5. Trzymam je w tablicy w skrypcie głównym i przed każdym strzałem odfiltrowuję martwe instancje. Jeśli tablica jest pełna — strzał jest blokowany.