class_name Lift extends AnimatableBody2D
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var lift_cast_up: RayCast2D = $lift_cast_up
@onready var lift_cast_down: RayCast2D = $lift_cast_down
@onready var player_detect_cast: RayCast2D = $player_detect_cast

@export var lift_id: int = 0
var starting_pos = "down"
var moving = false
var player_detected = false

var direction = Vector2.ZERO
func _ready() -> void:
	if lift_cast_up.is_colliding():
		starting_pos = "up"
	interaction_area.interact = Callable(self, "_on_interact")

func reverse_direction():
	if direction == Vector2.UP:
		direction = Vector2.DOWN
		lift_cast_up.enabled = false
		lift_cast_down.enabled = true
	elif direction == Vector2.DOWN:
		direction = Vector2.UP
		lift_cast_down.enabled = false
		lift_cast_up.enabled = true

func go_up():
	if starting_pos == "up":
		return
	direction = Vector2.UP
	lift_cast_down.enabled = false
	lift_cast_up.enabled = true
	moving = true

func go_down():
	if starting_pos == "down":
		return
	direction = Vector2.DOWN
	lift_cast_up.enabled = false
	lift_cast_down.enabled = true
	moving = true

func _on_interact():
	InteractionManager.can_interact = false
	if not moving:
		if starting_pos == "up":
			go_down()
		else:
			go_up()
func _physics_process(delta: float) -> void:
	if not moving:
		return
	
	var motion = direction * 100 * delta
	move_and_collide(motion)
	
	if player_detect_cast.is_colliding():
		if not player_detected:
			player_detected = true
			reverse_direction()
	else:
		player_detected = false

	
	if direction == Vector2.UP and lift_cast_up.is_colliding():
		moving = false
		InteractionManager.can_interact = true
		starting_pos = "up"
		lift_cast_down.enabled = true
	elif direction == Vector2.DOWN and lift_cast_down.is_colliding():
		moving = false		
		InteractionManager.can_interact = true
		starting_pos = "down"
		lift_cast_up.enabled = true
