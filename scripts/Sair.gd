extends Area2D


#Variável para atribuir o caminho da próxima cena. Contribuirá para que o código seja reutilizado de forma mais simples
@export var nextScene : String = ""

#Variável booleana para recer se o player está ou não na área2D para a transição.
#Essa variável está como global nesse script para que seja usada em mais de uma função.

func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		print("Dentro do if, ou seja, Enter e player on door funcionando")
		get_tree().change_scene_to_file(nextScene)
		print(nextScene)
		
