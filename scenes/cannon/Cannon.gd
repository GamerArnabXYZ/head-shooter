extends Node2D
# Aiming works with BOTH mobile touch and web mouse input.
# Drag to aim, release/tap fires. Angle is clamped so you can never shoot
# straight down into the cannon itself.

signal shot_fired

export var speed: float = 950.0
const MIN_ANGLE_MARGIN: float = 0.12  # ~7 degrees away from pure horizontal

var current_type: int = 0
var next_type: int = 0
var can_shoot: bool = true
var active_projectile: Node2D = null

onready var loaded_head_sprite: Sprite = $LoadedHead
onready var muzzle: Position2D = $Muzzle
onready var grid_manager: Node = get_parent().get_node("GridManager")
onready var projectiles: Node2D = get_parent().get_node("Projectiles")


func _ready() -> void:
	randomize()
	current_type = randi() % Globals.HeadType.size()
	next_type = randi() % Globals.HeadType.size()
	_refresh_loaded_head()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			_aim_at(event.position)
			_fire()
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		_aim_at(event.position)


func _aim_at(target: Vector2) -> void:
	var dir: Vector2 = target - global_position
	var angle: float = dir.angle()
	angle = clamp(angle, -PI + MIN_ANGLE_MARGIN, -MIN_ANGLE_MARGIN)
	rotation = angle + PI / 2.0


func _fire() -> void:
	if not can_shoot or active_projectile != null or grid_manager.board_locked:
		return
	can_shoot = false
	var head = Globals.HEAD_SCENE.instance()
	projectiles.add_child(head)
	head.global_position = muzzle.global_position
	head.set_type(current_type)
	head.is_flying = true
	var angle: float = rotation - PI / 2.0
	head.velocity = Vector2(cos(angle), sin(angle)) * speed
	active_projectile = head
	emit_signal("shot_fired")


func _physics_process(_delta: float) -> void:
	if active_projectile == null:
		return
	var landing: Dictionary = grid_manager.check_landing(active_projectile.global_position)
	if not landing.empty():
		grid_manager.place_head(int(landing["row"]), int(landing["col"]), active_projectile.type)
		active_projectile.queue_free()
		active_projectile = null
		current_type = next_type
		next_type = randi() % Globals.HeadType.size()
		_refresh_loaded_head()
		can_shoot = true


func _refresh_loaded_head() -> void:
	loaded_head_sprite.texture = Globals.get_head_texture(current_type)
