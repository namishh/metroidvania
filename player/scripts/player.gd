class_name Player extends CharacterBody2D

var states: Array[PlayerState]
var currentState : PlayerState :
	get : return states.front()
	
var previousState : PlayerState :
	get : return states[1]
var direction : Vector2 = Vector2.ZERO


#region states
@onready var idle: IdleState = %Idle
@onready var run: RunState = %Run
@onready var jump: JumpState = %Jump
@onready var fall: FallState = %Fall
@onready var dash: DashState = %Dash
#endregion

#region export variables
@export var gravity : float = 980.0
@export var base_move_speed: float = 120.0
@export var base_jump_velocity: float = 480.0
@export var coyote_time: float = 0.125
@export var gravity_multiplier :float = 1
@export var jump_buffer_time: float = 0.15

@export var dash_velocity: float = 300
@export var dash_duration: float = 0.25
@export var effect_delay: float = 0.04

@export var max_jump: int = 1;
@export var max_dash: int = 1;
#endregion

var dashes: int = 0;
var jumps: int = 0;

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
	changeState(currentState.physics_process(_delta))
