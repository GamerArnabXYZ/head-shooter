extends Node
# Autoload (singleton). Access anywhere as: Globals.xxx
# Registered in Project Settings > AutoLoad as "Globals".

enum HeadType { STEVE, CREEPER, ZOMBIE, SKELETON }

const HEAD_SCENE := preload("res://scenes/head/Head.tscn")

const HEAD_TEXTURES := {
	HeadType.STEVE: preload("res://assets/heads/steve.png"),
	HeadType.CREEPER: preload("res://assets/heads/creeper.png"),
	HeadType.ZOMBIE: preload("res://assets/heads/zombie.png"),
	HeadType.SKELETON: preload("res://assets/heads/skeleton.png"),
}

# --- Grid / board layout (tuned for the 720x1280 portrait viewport) ---
const CELL_SIZE := 90.0
const GRID_COLS := 8
const GRID_LEFT_MARGIN := 0.0
const GRID_TOP_MARGIN := 60.0
const DANGER_ROW := 10

const SAVE_PATH := "user://savegame.save"

var score: int = 0
var high_score: int = 0
var sound_on: bool = true

func _ready() -> void:
	load_game()

func get_head_texture(type: int) -> Texture:
	return HEAD_TEXTURES[type]

func reset_score() -> void:
	score = 0

func try_save_high_score() -> bool:
	if score > high_score:
		high_score = score
		save_game()
		return true
	return false

func save_game() -> void:
	var file := File.new()
	var err := file.open(SAVE_PATH, File.WRITE)
	if err != OK:
		push_warning("Globals: could not open save file for writing (%s)" % err)
		return
	var data := {
		"high_score": high_score,
		"sound_on": sound_on,
	}
	file.store_string(to_json(data))
	file.close()

func load_game() -> void:
	var file := File.new()
	if not file.file_exists(SAVE_PATH):
		return
	var err := file.open(SAVE_PATH, File.READ)
	if err != OK:
		return
	var text := file.get_as_text()
	file.close()
	var parsed = parse_json(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		high_score = int(parsed.get("high_score", 0))
		sound_on = bool(parsed.get("sound_on", true))

func toggle_sound() -> bool:
	sound_on = not sound_on
	save_game()
	return sound_on
