class_name LiftButton extends Sprite2D
@export var lift: Lift = null
@export var call_from_top: bool = false
@onready var interaction_area: InteractionArea = $InteractionArea
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if call_from_top:
		lift.go_down()
		return
	lift.go_up()

		
func _process(delta: float) -> void:
	pass
