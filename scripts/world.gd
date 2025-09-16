extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.update_scene("World");
	$Player.global_position = Global.update_position();
