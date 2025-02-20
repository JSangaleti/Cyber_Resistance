extends Node2D

signal player_visited_cafeteria #Sinal para a missão 02, _task_02(), de tasks.gd

func _ready() -> void:
	Global.update_scene("Cafeteria");
	$Player.global_position = Global.update_position();
	
	emit_signal("player_visited_cafeteria")
	print("Sinal emitido, world")
		
	#var actual_scene : StringName  = Global.actual_scene
	#var last_scene : StringName = Global.last_scene
	#
	#if actual_scene == "Cafeteria" and last_scene == "World":
		##$Player.position = Vector2(241,322)
		#$Player.global_position = Vector2(241,322)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
