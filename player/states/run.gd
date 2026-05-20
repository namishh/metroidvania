class_name RunState extends PlayerState

func init() -> void:
	pass
	
func enter() -> void:
	print("[ENTER]: Run")
	pass
	
func exit() -> void:
	print("[EXIT]: Run")
	pass
	
func handle_input(_e: InputEvent) -> PlayerState:
	if _e.is_action_pressed("jump") and Input.is_action_pressed("ui_down") and player.one_way_raycast.is_colliding():
		player.position.y += 4
		return fall
	if _e.is_action_pressed("jump") and player.jumps < player.max_jump:
		return jump
	if _e.is_action_pressed("dash") and player.dashes < player.max_dash:
		return dash 
	return next_state
	
func process(delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state

func physics_process(delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.base_move_speed
	if player.is_on_floor() == false:
		if player.is_on_wall():
			return wall_slide
		return fall
	player.dashes = 0
	player.jumps = 0
	return next_state
