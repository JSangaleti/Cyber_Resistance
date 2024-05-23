extends Area2D

#Variável para atribuir o caminho da próxima cena. Contribuirá para que o código seja reutilizado de forma mais simples
@export var nextScene : String = ""

#Variável booleana para recer se o player está ou não na área2D para a transição.
#Essa variável está como global nesse script para que seja usada em mais de uma função.
var player_on_door : bool = false

func _on_body_entered(body):
# Verificando se o body está no grupo Player. 
# Na cena "player", incluí o mesmo em um grupo denominado Player. 
	if body.is_in_group("Player"):
		player_on_door = true

func _on_body_exited(body):
	player_on_door = false

func _process(delta):
	if player_on_door and Input.is_action_just_pressed("Enter"):
		get_tree().change_scene_to_file(nextScene)
		
		
