extends Control

var newGame : String = "res://scenes/world.tscn"

func _on_bt_novo_jogo_pressed() -> void:
	get_tree().change_scene_to_file(newGame)
