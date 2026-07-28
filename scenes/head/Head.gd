extends Area2D
# One mob head. Reused both as a static grid cell AND as the flying shot
# fired from the cannon (see `is_flying`).

var type: int = 0
var grid_row: int = -1
var grid_col: int = -1
var is_flying: bool = false
var velocity: Vector2 = Vector2.ZERO

onready var sprite: Sprite = $Sprite


func set_type(new_type: int) -> void:
	type = new_type
	sprite.texture = Globals.get_head_texture(type)


func _physics_process(delta: float) -> void:
	if not is_flying:
		return
	position += velocity * delta
	_bounce_off_walls()


func _bounce_off_walls() -> void:
	var vp_width: float = get_viewport_rect().size.x
	var radius: float = Globals.CELL_SIZE * 0.5
	if position.x - radius <= 0.0 and velocity.x < 0.0:
		position.x = radius
		velocity.x = -velocity.x
	elif position.x + radius >= vp_width and velocity.x > 0.0:
		position.x = vp_width - radius
		velocity.x = -velocity.x
