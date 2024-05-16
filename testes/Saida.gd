extends Area2D

var on_door := false

func _on_body_entered(body):
 on_door = true
 print("esta na porta")


func _on_body_exited(body):
 on_door = false
 print("esta na fora da porta")

func _process(delta: float) -> void:
 if on_door and Input.is_action_just_pressed("Enter"):
  get_tree().change_scene_to_file("res://game/game.tscn")

