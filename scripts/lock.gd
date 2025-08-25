extends Area2D

@export var reward_part: String = "parte_1_da_senha"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # garanta que o Player está no grupo "player"
		# entrega a parte da senha
		GlobalProgressPuzzles.add_password_part(reward_part)
		# remove o cadeado da cena
		queue_free()
		
		get_tree().change_scene_to_file("res://scenes/computer.tscn")
