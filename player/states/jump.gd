class_name JumpState extends PlayerState

func init() -> void:
	pass
	
func enter() -> void:
	print("[ENTER]: Jump")
	player.jumps += 1
	player.velocity.y = -player.base_jump_velocity
	if not Input.is_action_pressed("jump"):
		player.velocity.y *= 0.5

func exit() -> void:
	print("[EXIT]: Jump")
	pass
	
func handle_input(_e: InputEvent) -> PlayerState:
	if _e.is_action_pressed("dash") and player.dashes < player.max_dash:
		return dash
	if _e.is_action_pressed("jump") and player.jumps < player.max_jump:
		return jump
	if _e.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state
	
func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.is_on_wall() and (player.is_on_floor() == false):
		var wall_normal = player.get_wall_normal()
		var pressing_into_wall = (wall_normal.x > 0 and Input.is_action_pressed("ui_left")) or \
								(wall_normal.x < 0 and Input.is_action_pressed("ui_right"))
		if pressing_into_wall:
			return wall_slide
	elif player.velocity.y >= 0:
		return fall
	player.horizontal_movement()
	return next_state
