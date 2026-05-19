class_name WallSlideState extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	print("[ENTER]: WallSlide")
	player.gravity_multiplier = 0.4
	player.velocity.y = 0
	
func exit() -> void:
	player.gravity_multiplier = 1

func process(delta: float) -> PlayerState:
	return next_state
	
func physics_process(delta: float) -> PlayerState:
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
