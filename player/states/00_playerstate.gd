class_name PlayerState extends Node

var player: Player
var next_state: PlayerState = null

#region /// state references
@onready var idle: IdleState = %Idle
@onready var jump: JumpState = %Jump
@onready var fall: FallState = %Fall
@onready var run: RunState = %Run
@onready var dash: DashState = %Dash
@onready var wall_slide: WallSlideState  = %WallSlide
@onready var wall_jump: WallJumpState = %WallJump
@onready var swim_run: SwimRunState = %SwimRun
@onready var swim_idle: SwimIdleState = %SwimIdle

#endregion

func init() -> void:
	print("initing, ", name)
	pass
	
func enter() -> void:
	print("entering, ", name)
	pass
	
func exit() -> void:
	print("exiting, ", name)
	pass
	
func handle_input(_e: InputEvent) -> PlayerState:
	return next_state
	
func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state
		
