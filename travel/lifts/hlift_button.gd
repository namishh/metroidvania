class_name HLiftButton extends Sprite2D
@export var lift: HorizontalLift = null
@export var call_from_left: bool = false
@onready var interaction_area: InteractionArea = $InteractionArea
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if call_from_left:
		lift.go_left()
		return
	lift.go_right()

		
func _process(delta: float) -> void:
	pass
