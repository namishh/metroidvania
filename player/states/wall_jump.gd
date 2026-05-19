class_name WallJumpState extends PlayerState

var wall_normal: Vector2 = Vector2.ZERO

func init() -> void:
	pass

func enter() -> void:
	print("[ENTER]: WallJump")
	player.jumps += 1
	wall_normal = player.get_wall_normal()
	player.velocity.y = -player.base_jump_velocity
	player.velocity.x = wall_normal.x * player.wall_jump_push_force

func exit() -> void:
	print("[EXIT]: WallJump")

func handle_input(_e: InputEvent) -> PlayerState:
	if _e.is_action_pressed("dash") and player.dashes < player.max_dash:
		return dash
	if _e.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	if player.velocity.y >= 0:
		return fall
	return next_state
