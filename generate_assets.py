"""
Generates simple ORIGINAL pixel-art placeholder textures for the game.
These are generic "blocky mob head" designs (not Mojang/Minecraft's actual
copyrighted textures) so the project is safe to ship. Swap these PNGs in
assets/heads/ and assets/ui/ with your own art anytime -- code doesn't change.
"""
from PIL import Image

GRID = 16          # design on a 16x16 pixel grid...
SCALE = 8           # ...then scale up x8 = 128x128 final texture (crisp/blocky)
SIZE = GRID * SCALE


def new_grid():
    return [[None for _ in range(GRID)] for _ in range(GRID)]


def render(grid, path):
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    px = img.load()
    for y in range(GRID):
        for x in range(GRID):
            c = grid[y][x]
            if c is None:
                continue
            for dy in range(SCALE):
                for dx in range(SCALE):
                    px[x * SCALE + dx, y * SCALE + dy] = c
    img.save(path)
    print("wrote", path)


def fill_rect(grid, x0, y0, x1, y1, color):
    for y in range(y0, y1):
        for x in range(x0, x1):
            if 0 <= x < GRID and 0 <= y < GRID:
                grid[y][x] = color


# ---------- STEVE (skin tone + brown hair + blue eyes) ----------
def make_steve():
    g = new_grid()
    skin = (222, 168, 133, 255)
    hair = (91, 60, 34, 255)
    eye = (60, 110, 200, 255)
    dark = (0, 0, 0, 255)
    fill_rect(g, 1, 1, 15, 15, skin)
    fill_rect(g, 1, 1, 15, 4, hair)
    fill_rect(g, 1, 4, 3, 8, hair)
    fill_rect(g, 13, 4, 15, 8, hair)
    fill_rect(g, 4, 6, 6, 8, eye)
    fill_rect(g, 10, 6, 12, 8, eye)
    fill_rect(g, 6, 11, 10, 12, dark)
    return g


# ---------- CREEPER (green + black face pattern) ----------
def make_creeper():
    g = new_grid()
    green = (63, 168, 63, 255)
    dark_green = (45, 130, 45, 255)
    black = (20, 30, 20, 255)
    fill_rect(g, 1, 1, 15, 15, green)
    fill_rect(g, 2, 2, 6, 5, dark_green)
    fill_rect(g, 10, 2, 14, 5, dark_green)
    fill_rect(g, 5, 4, 7, 8, black)
    fill_rect(g, 9, 4, 11, 8, black)
    fill_rect(g, 6, 8, 10, 9, black)
    fill_rect(g, 5, 9, 7, 13, black)
    fill_rect(g, 9, 9, 11, 13, black)
    return g


# ---------- ZOMBIE (decayed green skin) ----------
def make_zombie():
    g = new_grid()
    green = (86, 140, 90, 255)
    dark = (55, 95, 60, 255)
    eye = (140, 20, 20, 255)
    mouth = (25, 15, 15, 255)
    fill_rect(g, 1, 1, 15, 15, green)
    fill_rect(g, 2, 2, 5, 5, dark)
    fill_rect(g, 11, 9, 14, 12, dark)
    fill_rect(g, 4, 6, 6, 8, eye)
    fill_rect(g, 10, 6, 12, 8, eye)
    fill_rect(g, 6, 11, 10, 12, mouth)
    return g


# ---------- SKELETON (bone white/gray) ----------
def make_skeleton():
    g = new_grid()
    bone = (223, 223, 214, 255)
    shade = (180, 180, 170, 255)
    socket = (25, 25, 25, 255)
    fill_rect(g, 1, 1, 15, 15, bone)
    fill_rect(g, 1, 1, 15, 3, shade)
    fill_rect(g, 4, 5, 7, 8, socket)
    fill_rect(g, 9, 5, 12, 8, socket)
    fill_rect(g, 6, 10, 10, 11, shade)
    fill_rect(g, 7, 11, 9, 13, shade)
    return g


# ---------- CANNON (stone-grey blocky turret, points up by default) ----------
def make_cannon():
    g = new_grid()
    stone = (120, 120, 128, 255)
    stone_dark = (85, 85, 92, 255)
    barrel = (55, 55, 60, 255)
    fill_rect(g, 3, 8, 13, 16, stone)
    fill_rect(g, 3, 8, 13, 10, stone_dark)
    fill_rect(g, 6, 0, 10, 9, barrel)
    fill_rect(g, 5, 8, 6, 9, stone_dark)
    fill_rect(g, 10, 8, 11, 9, stone_dark)
    return g


def make_icon():
    g = new_grid()
    bg = (40, 44, 52, 255)
    green = (63, 168, 63, 255)
    black = (20, 30, 20, 255)
    fill_rect(g, 0, 0, 16, 16, bg)
    fill_rect(g, 3, 3, 13, 13, green)
    fill_rect(g, 5, 5, 7, 8, black)
    fill_rect(g, 9, 5, 11, 8, black)
    fill_rect(g, 6, 9, 10, 10, black)
    return g


render(make_steve(), "assets/heads/steve.png")
render(make_creeper(), "assets/heads/creeper.png")
render(make_zombie(), "assets/heads/zombie.png")
render(make_skeleton(), "assets/heads/skeleton.png")
render(make_cannon(), "assets/ui/cannon.png")
render(make_icon(), "icon.png")
