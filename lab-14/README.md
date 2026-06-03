# Laboratorium 14

## Opis

Celem laboratorium była dodanie mechaniki bossa i poprawki w kodzie.

## Zrealizowane zadania

Dodano bossa z dwoma hitboxami, wykorzystano maszynę stanów zgodnie z poleceniem. Dodano cząsteczki, dodano prawidłową logikę bossa. 

Wykonano refaktoryzacje kodu: 
- Magiczne liczby: czy 0.3, 60, 5 mają nazwy? const lub @export.
- Długie metody: funkcja > 25 linii — wydziel spójny fragment.
- Zakotwiczone ścieżki węzłów: get_node("/root/Main/...") w kodzie — zastąp @export lub grupą.
- Powielony kod: logika spawnu pocisku w wielu miejscach — wydziel jako pomocnik.
- Sygnały zamiast wywołań: węzeł wywołuje metodę na innym, gdzie wystarczyłby sygnał.

## Znane błędy
- Błąd zliczania przeciwników
- Boss wychodzi poza obszar gry
- menu końca poziomu potrafi się źle wyświetlić.

## Co można by poprawić:
- Wykporzystać lepsze modele niż podstawowe
- Wykonać pełny refactor mechaniki. Nie ma sensu przesuwać gracza po długiej mapie, lepiej zostawić tunel statycznie i generować nowe fale
- Zrobić bardziej dynamiczne fale przeciwników z różnymi formacjami
- Poprawić walkę z bossem
- Poprawić sposób oświetlenia sceny
