extends Node2D



func _change_scene_to(next_scene_path: String) -> void:
	get_tree().change_scene_to_file(next_scene_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

