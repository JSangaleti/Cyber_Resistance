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
		
#	Editando a variável Global para corrigir a posição do player ao passar pela transição de cenas
#		A variável from_scene recebe o nome do nó principal de onde está a área2D que o player entrou. 
		#Global.from_scene = get_parent().name
		#print("Variável Global Caminho: " + Global.from_scene)

func _on_body_exited(_body):
	player_on_door = false
	
func _process(_delta):
	if player_on_door and Input.is_action_just_pressed("action"):
		get_tree().change_scene_to_file(nextScene)

		print(nextScene)
		

	
		
		
		
