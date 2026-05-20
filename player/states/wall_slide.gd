class_name WallSlideState extends PlayerState

var last_wall_normal: Vector2 = Vector2.ZERO

func init() -> void:
	pass

func enter() -> void:
	print("[ENTER]: WallSlide")
	if player.wall_cling:
		player.gravity_multiplier = 0
		player.velocity.y = 0
	else:
		player.gravity_multiplier = 0.4
		player.velocity.y *= 0.35
	player.dashes = 0
	player.jumps = 0
	last_wall_normal = player.get_wall_normal()

	
func handle_input(_e: InputEvent) -> PlayerState:
	if _e.is_action_pressed("jump"):
		return wall_jump
	return next_state


func exit() -> void:
	player.gravity_multiplier = 1

func process(_delta: float) -> PlayerState:
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	if player.is_on_wall():
		var wall_normal = player.get_wall_normal()
		var pressing_into_wall = (wall_normal.x > 0 and Input.is_action_pressed("ui_left")) or \
								(wall_normal.x < 0 and Input.is_action_pressed("ui_right"))
		if not pressing_into_wall:
			return fall
	else:
		return fall
	return next_state
