class_name FallState extends PlayerState

var coyote_timer :float = 0
var buffer_timer :float = 0
var dash_buffer_timer: float = 0



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
	if _e.is_action_pressed("dash"):
		if player.dashes < player.max_dash:
			return dash
		else:
			dash_buffer_timer = player.dash_buffer_time 
	if _e.is_action_pressed("jump"):
		if coyote_timer > 0 or player.jumps < player.max_jump:
			return jump
		else:
			buffer_timer = player.jump_buffer_time
	return next_state

	
	
func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	dash_buffer_timer -= delta

	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.dashes = 0
		player.jumps = 0
		if buffer_timer > 0:
			return jump
		if dash_buffer_timer > 0:
			return dash

		if player.water_raycast.is_colliding():
			return swim_idle
		return idle
	if player.is_on_wall() and (player.is_on_floor() == false):
		var wall_normal = player.get_wall_normal()
		var pressing_into_wall = (wall_normal.x > 0 and Input.is_action_pressed("ui_left")) or \
								(wall_normal.x < 0 and Input.is_action_pressed("ui_right"))
		if pressing_into_wall:
			return wall_slide
	player.horizontal_movement()
	return next_state
