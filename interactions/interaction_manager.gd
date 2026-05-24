extends Node2D


@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var label: Label = $Label

const base_text: String = "[F] to "

var active_areas: Array[InteractionArea] = []
var can_interact: bool = true

var used_areas: Array[InteractionArea] = []

func register_area(area: InteractionArea):
	if area in used_areas:
		return
	active_areas.push_back(area)

	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		
		label.global_position.y -= 36
		label.global_position.x -= label.size.x / 2
		
		label.show()
	else:
		label.hide()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			if active_areas.size() > 0 && active_areas[0].one_time:
				used_areas.push_back(active_areas[0])
				unregister_area(active_areas[0])


		
func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea):
	var a1 = player.global_position.distance_to(area1.global_position)
	var a2 = player.global_position.distance_to(area2.global_position)
	
	return a1 < a2
