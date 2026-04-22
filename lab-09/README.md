# Lab 09 – Projekt: Scena 3D i Ruch po Ścieżce

## Podsumowanie pracy

Zrealizowano scenę 3D w środowisku Godot, wykorzystując system ścieżek oraz skryptowanie ruchu obiektów.

### Zrealizowane funkcjonalności

- **Utworzono scenę 3D składającą się z:**
    - `Node3D` (Root sceny)
    - `DirectionalLight3D` (Oświetlenie kierunkowe)
    - `Path3D` (Definicja trasy ruchu)
    - `PathFollow3D` (Uchwyt poruszający się po trasie)
    - `MeshInstance3D` (Model 3D obiektu)
    - `Camera3D` (Widok z perspektywy gracza/sceny)

- **Implementacja skryptów (Logic):**
    1. **Skrypt PathFollow3D:** Odpowiada za przemieszczanie kamery oraz `MeshInstance3D` wzdłuż zdefiniowanej ścieżki. Czas pełnego przejazdu wynosi około 9 sekund.
    2. **Skrypt sterowania MeshInstance3D:** Umożliwia zmianę pozycji obiektu w płaszczyznach XY. 
        - Zastosowano mechanizm `clamp` (ograniczenie obszaru) oraz normalizację wektorów.
        - Wprowadzono 3 zmienne konfiguracyjne opisujące limity obszaru poruszania oraz prędkość.
