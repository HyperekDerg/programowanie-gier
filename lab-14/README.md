# Laboratorium 13

## Opis

Celem laboratorium była centralizacja stanu gry oraz rozbudowa warstwy wizualnej i dźwiękowej. Zaimplementowano globalny system zarządzania rozgrywką (Singleton), interfejs użytkownika (HUD) nakładany na scenę 3D, pełną pętlę menu oraz system efektów dźwiękowych reagujących na zdarzenia w grze. Wykonano wszystkie polecenia opisane w instrukcji.

## Zrealizowane zadania

GameManager jako Autoload
Żeby wróg i statek nie musieli się nawzajem szukać po scenach, zrobiono z game_manager.gd Singletona (Autoload).
- Trzyma zmienne: score, lives, player_hp i player_max_hp.
- Ma metody add_score() i player_hit(), które same pilnują odejmowania HP, a jak hp spadnie do zera, to zabierają życie i resetują stan. Przy 0 żyć leci sygnał game_over.
- Podpięto to pod sygnał died wroga z Lab 11 i take_damage gracza z Lab 12 (stare lokalne HP wywalone).

*HUD w CanvasLayer*
Wrzucono węzeł CanvasLayer do głównej sceny, żeby UI nie latało za kamerą w 3D.
- W lewym górnym rogu Label z wynikiem, w prawym górnym Label z życiami.
- Na dole dodano ProgressBar podpięty pod HP.
- Wszystko ładnie zakotwiczone (Anchor Preset), żeby się nie rozjechało przy zmianie okna. W _ready podpięto sygnały z GameManagera, więc napisy aktualizują się same w locie.

*Pętla scen*
Zrobiono w końcu normalny obieg gry przez change_scene_to_file(). Dorobione sceny na Controlach:
- main_menu.tscn — odpala się jako pierwsza, resetuje stan i ma przycisk do startu.
- game_over.tscn i level_complete.tscn — pokazują czy wygrałeś, czy przegrałeś, wyświetlają punkty i pozwalają wrócić do menu.
- Wszystko spięte lambdami w mainie, pętla menu -> gra -> game over -> menu działa bez wywalania błędów.

*Dźwięk zdarzeń*

Dźwięki ogarnięto centralnie w GameManagerze, żeby nie znikały przy queue_free() wroga. Dynamicznie tworzone są trzy AudioStreamPlayer podpięte pod lambdy z sygnałów:
- dźwięk zdobycia punktów (enemy_killed),
- dźwięk dostania hita (player_damaged),
- smutny dźwięk przegranej (game_over).
