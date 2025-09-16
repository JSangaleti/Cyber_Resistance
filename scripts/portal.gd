extends Area2D

# Quais desafios precisam estar completos
@export var required_challenges: Array = ["labirinto", "caça-senhas", "enigma", "quiz"]

# Para animação de abertura (opcional)
@onready var sprite = $Sprite2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalProgressPuzzles.all_challenges_done(required_challenges):
			open_portal()
		else:
			$Label.text = "Para finalizar, você precisa concluir todas as tarefas e minigames"
			await get_tree().create_timer(2.0).timeout
			$Label.text = ""
func open_portal():
	Global.finish_game_timer()
	$Label.text = "PORTAL ABERTO! \n3... 2... 1..."
	await get_tree().create_timer(2.0).timeout
	$Label.text = ""
	get_tree().change_scene_to_file("res://scenes/estatisticas_finais.tscn")

	
	sprite.modulate = Color(0,1,0) # muda cor para verde
	queue_free() # remove o portal, permitindo passagem
