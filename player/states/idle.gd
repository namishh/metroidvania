class_name IdleState extends PlayerState

func init() -> void:
	pass
	
func enter() -> void:
	print("[ENTER]: Idle")
	pass
	
func exit() -> void:
	print("[EXIT]: Idle")
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
	
func process(_delta: float) -> PlayerState:
	if player.water_raycast.is_colliding():
		return swim_idle
	if player.direction.x != 0:
		return run

	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	player.dashes = 0
	player.jumps = 0
	return next_state
		
