extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
		#Os comandos seguintes são para o ajuste de posição do personagem ao passar por uma transição de cenas.
	if Global.from_scene != null:
		if(Global.cena == "Computador"):
			print("ignorando...")
#			O erro é o seguinte: sem esse if, quando vai sair do computador e voltar pra cafeteria, o script Positions
#			tenta encontrar o nó Cafeteriapos. Porém, dentro do pc não é necessário uma posição, visto que o player não
#			entra dentro da cena. Contudo, criei um script chamado positionComputer, que faz apenas a mudança para a próxima cena,
#			sem se preocupar com a posição do Player. 

#			Está assim porque ainda não sei como pegar o nome da cena. 
			Global.cena = "ZERO"
		else:
			$Player.set_position(get_node(Global.from_scene + "pos").position)

#------------------------------------------------------------------------------------------------------


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
