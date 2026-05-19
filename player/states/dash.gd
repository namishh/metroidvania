class_name DashState extends PlayerState

var dir: float = 1.0
var time: float = 0.0


func get_dash_direction():
	dir = 1.0
	if $"../../Sprite2D".flip_h == true:
		dir = -1.0

func init() -> void:
	pass
	
func enter() -> void:
	print("[Entering]: ", name)
	get_dash_direction()
	time = player.dash_duration
	player.velocity.y = 0
	player.gravity_multiplier = 0
	player.dashes += 1	
	## TODO: Set iframes if want to.
	pass
	
func exit() -> void:
	print("[Exit]: ", name)
	player.gravity_multiplier = 1
	pass
	
func handle_input(_e: InputEvent) -> PlayerState:
	return next_state
	
func process(delta: float) -> PlayerState:
	time -= delta
	if time <= 0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	return next_state

func physics_process(delta: float) -> PlayerState:
	if time > 0:
		player.velocity.x = (player.dash_velocity * (time / player.dash_duration) + player.dash_velocity) * dir
	else:
		return idle
	return next_state
