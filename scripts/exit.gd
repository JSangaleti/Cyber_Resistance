extends Area2D


#Variável para atribuir o caminho da próxima cena. Contribuirá para que o código seja reutilizado de forma mais simples
@export var nextScene : String = ""

var player_na_area = false
#Variável booleana para recer se o player está ou não na área2D para a transição.
#Essa variável está como global nesse script para que seja usada em mais de uma função.

func _process(delta):
#		Comparo com o caminho para que cada tecla realmente execute apenas sua função, de sair ou entrar na cena do pc.
#		Sem tal comparação, tanto a tecla Esc quanto a tecla E (ação) podem ser usadas para sair ou entrar na cena. 
	if Input.is_action_just_pressed("Esc") and nextScene != "res://scenes/computador.tscn":
		print("Dentro do if, ou seja, Esc e player on door funcionando")
		Interactions.update_interactions_painel() # Atualizando painel de interações 
		get_tree().change_scene_to_file(nextScene)

			
		print(nextScene)
	elif Input.is_action_just_pressed("action") and nextScene == "res://scenes/computador.tscn" and player_na_area:
		get_tree().change_scene_to_file(nextScene)
		print(nextScene)
		
		

# Sinal para verificar se o player está na área;
func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_na_area = true
	
# Sinal para verificar se o player está na área;
func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_na_area = false
