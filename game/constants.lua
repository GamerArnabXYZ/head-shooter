local M = {}

M.SCREEN_W = 720
M.SCREEN_H = 1280

M.CELL = 80
M.RADIUS = 40
M.ROW_H = 70

M.COLS_WIDE = 8
M.COLS_NARROW = 7

M.GRID_TOP_Y = 1150
M.GRID_LEFT_X = 80

M.GAMEOVER_Y = 280
M.SHOOTER_X = 360
M.SHOOTER_Y = 150

M.SHOT_SPEED = 1000
M.AIM_MIN_DEG = 20
M.AIM_MAX_DEG = 160

M.MOB_TYPES = {
	"mob_zomblin", "mob_bonecap", "mob_oinker",
	"mob_crawler", "mob_slimey", "mob_shadewalker"
}
M.ACTIVE_MOB_COUNT = 5
M.SHOTS_PER_CEILING_DROP = 8
M.INITIAL_ROWS = 5

return M
