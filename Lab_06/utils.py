SCREEN_W = 800
SCREEN_H = 600


# funkcja pomocnicza do rysowania "duchów" obiektów przy krawędziach ekranu
def ghost_positions(x: float, y: float, size: float) -> list[tuple[float, float]]:
    xs = [x]
    ys = [y]

    if x < size:
        xs.append(x + SCREEN_W)
    elif x > SCREEN_W - size:
        xs.append(x - SCREEN_W)

    if y < size:
        ys.append(y + SCREEN_H)
    elif y > SCREEN_H - size:
        ys.append(y - SCREEN_H)

    return [(px, py) for px in xs for py in ys]
