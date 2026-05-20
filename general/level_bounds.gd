@tool
class_name LevelBounds extends Node2D

@export_range(480, 4096, 32, "suffix:px") var width: int = 480 \
: set = _on_width_changed
@export_range(270, 4096, 16, "suffix:px") var height: int = 270 \
: set = _on_height_changed
func _ready() -> void:
	z_index = 1000
	
	if Engine.is_editor_hint():
		return
		
	var cam: Camera2D = null;
	
	while not cam:
		await get_tree().process_frame
		cam = get_viewport().get_camera_2d()
		
	cam.limit_left = int(global_position.x)
	cam.limit_top = int(global_position.y)
	
	cam.limit_right =  int(global_position.x) + width
	cam.limit_bottom = int(global_position.y) + height

	
	pass

func _on_width_changed(nw: int) -> void:
	width = nw
	queue_redraw()
	pass
	
func _on_height_changed(nh: int) -> void:
	height = nh
	queue_redraw()
	pass

func _draw() -> void:
	if Engine.is_editor_hint():
		var r: Rect2 = Rect2(Vector2.ZERO, Vector2(width, height))
		draw_rect(r, Color.CORNFLOWER_BLUE, false, 2)
