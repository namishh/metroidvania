class_name Player extends CharacterBody2D

var states: Array[PlayerState]
var currentState : PlayerState :
	get : return states.front()
	
var previousState : PlayerState :
	get : return states[1]
var direction : Vector2 = Vector2.ZERO

@onready var one_way_raycast: RayCast2D = $OneWayRaycast
@onready var water_raycast: RayCast2D = $WaterRaycast


#region export variables
@export var gravity : float = 980.0
@export var base_move_speed: float = 120.0
@export var base_jump_velocity: float = 480.0
@export var coyote_time: float = 0.125
@export var gravity_multiplier :float = 1
@export var jump_buffer_time: float = 0.15

@export var wall_cling: bool = false

@export var dash_velocity: float = 300
@export var dash_duration: float = 0.25
@export var effect_delay: float = 0.04

@export var wall_jump_push_force: float = 320

@export var wall_jump_lock_time: float = 0.05

@export var max_jump: int = 1;
@export var max_dash: int = 1;
#endregion

var dashes: int = 0;
var jumps: int = 0;
var wall_contact_timer: float = 0.0
var wall_jump_lock_timer: float = 0.0
var last_wall_normal: Vector2 = Vector2.ZERO

func init_states() -> void:

	states = []
	
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
			
	if states.size() == 0:
		return
	
	for state in states:
		state.init()
		
	print(states)
		
	changeState(currentState)
	currentState.enter()
	$Label.text = currentState.name

	
func changeState(ns: PlayerState) -> void:
	if ns == null:
		return
	elif ns == currentState:
			return
	
	if currentState:
		currentState.exit()
		
	states.push_front(ns)
	$Label.text = currentState.name

	currentState.enter()
	states.resize(3)
		

func _ready() -> void:
	init_states()
	pass

func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handle_input(event))

func update_direction() -> void:
	var dirx = Input.get_axis("ui_left", "ui_right")
	var diry = Input.get_axis("ui_up", "ui_down")
	
	direction = Vector2(dirx, diry)
	if dirx > 0:
		$Sprite2D.flip_h = false
	elif dirx < 0:
		$Sprite2D.flip_h = true

func _process(_delta: float) -> void:
	update_direction()
	changeState(currentState.process(_delta))
	
	
func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta * gravity_multiplier
	move_and_slide()
	update_wall_contact(_delta)
	changeState(currentState.physics_process(_delta))

func update_wall_contact(delta: float) -> void:
	if is_on_wall() and not is_on_floor():
		last_wall_normal = get_wall_normal()
	
	else:
		wall_contact_timer = maxf(wall_contact_timer - delta, 0.0)
	wall_jump_lock_timer = maxf(wall_jump_lock_timer - delta, 0.0)


func can_wall_jump() -> bool:
	return wall_contact_timer > 0.0 and last_wall_normal != Vector2.ZERO
