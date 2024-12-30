extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.update_scene("Cafeteria");
	$Player.global_position = Global.update_position();
	#var actual_scene : StringName  = Global.actual_scene
	#var last_scene : StringName = Global.last_scene
	#
	#if actual_scene == "Cafeteria" and last_scene == "World":
		##$Player.position = Vector2(241,322)
		#$Player.global_position = Vector2(241,322)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
