class_name HorizontalLift extends AnimatableBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var ray_left: RayCast2D = $ray_left
@onready var ray_right: RayCast2D = $ray_right
@onready var player_ray_right: RayCast2D = $player_ray_right
@onready var player_ray_left: RayCast2D = $player_ray_left

@export var lift_speed: int = 100

var starting_pos = "left"
var moving = false
var direction = Vector2.ZERO

func _ready() -> void:
	if ray_right.is_colliding():
		starting_pos = "right"
	interaction_area.interact = Callable(self, "_on_interact")

func reverse_direction():
	if direction == Vector2.RIGHT:
		direction = Vector2.LEFT
		ray_right.enabled = false
		ray_left.enabled = true
	elif direction == Vector2.LEFT:
		direction = Vector2.RIGHT
		ray_left.enabled = false
		ray_right.enabled = true

func go_right():
	if starting_pos == "right":
		return
	direction = Vector2.RIGHT
	ray_left.enabled = false
	ray_right.enabled = true
	moving = true

func go_left():
	if starting_pos == "left":
		return
	direction = Vector2.LEFT
	ray_right.enabled = false
	ray_left.enabled = true
	moving = true

func _on_interact():
	InteractionManager.can_interact = false
	if not moving:
		if starting_pos == "right":
			go_left()
		else:
			go_right()

func _physics_process(delta: float) -> void:
	if direction == Vector2.RIGHT and player_ray_right.is_colliding():
		var collider = player_ray_right.get_collider()
		if collider and collider.is_in_group("player"):
			reverse_direction()
	elif direction == Vector2.LEFT and player_ray_left.is_colliding():
		var collider = player_ray_left.get_collider()
		if collider and collider.is_in_group("player"):
			reverse_direction()

	if not moving:
		return

	var motion = direction * lift_speed * delta
	move_and_collide(motion)

	if direction == Vector2.RIGHT and ray_right.is_colliding():
		moving = false
		InteractionManager.can_interact = true
		starting_pos = "right"
		ray_left.enabled = true
	elif direction == Vector2.LEFT and ray_left.is_colliding():
		moving = false
		InteractionManager.can_interact = true
		starting_pos = "left"
		ray_right.enabled = true
