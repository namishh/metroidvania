class_name FallState extends PlayerState

var coyote_timer :float = 0
var buffer_timer :float = 0


func init() -> void:
	pass
	
func enter() -> void:
	player.gravity_multiplier = 1.165
	if player.previousState != jump:
		coyote_timer = player.coyote_time
	print("[ENTER]: Fall")
	pass
	
func exit() -> void:
	player.gravity_multiplier = 1
	print("[EXIT]: Fall")


	pass
	
func handle_input(_e: InputEvent) -> PlayerState:
	if _e.is_action_pressed("dash") and player.dashes < player.max_dash:
		return dash 
	if _e.is_action_pressed("jump") and player.jumps < player.max_jump:
		if coyote_timer > 0 or player.jumps < player.max_jump:
			return jump
		else:
			buffer_timer = player.jump_buffer_time
	return next_state
	
func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta

	return next_state

func physics_process(delta: float) -> PlayerState:
	if player.is_on_floor():
		player.dashes = 0
		player.jumps = 0
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.base_move_speed
	return next_state
