extends Node2D


func _ready() -> void:
	Global.update_scene("University");
	$Player.global_position = Global.update_position();
