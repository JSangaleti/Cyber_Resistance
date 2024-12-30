extends Node2D


#Variável para identificar de que Cena o personagem veio. 
#Será usada para auxiliar com o Posicionamento do player após passar por uma transição de cenas. 
#var from_scene
##Variável criada com o intuito de retirar o erro de precisar de uma position na Cena Computador. 
##Com essa variável, é possível verificar em que cena está e então, se estiver na cena Computador, ignorará a Position
#var cena : String
#var cena_anterior : String = ""

var actual_scene : StringName
var last_scene : StringName

#Variável para identificar se o Player está em uma Missão
var missao_ativa : bool
var nome_missao : String
var missoes_concluidas : Array = []

#Sobre diálogos específicos e essenciais na história do jogo.
var dialogo_especifico : String = ""
var dialogos_executados : Array = []

#Nas configurações do projeto, esta cena foi adicionada como Global. Contudo, todas as variáveis e funções
#aqui incluídas, poderão ser acessadas de qualquer cena ou nó do projeto. 

func update_scene(actual: StringName) -> void:
	last_scene = actual_scene
	actual_scene = actual

func update_position():
#	CENA ATUAL: CAFETERIA
	match actual_scene:
		"Cafeteria":
			match last_scene:
				"World":
					return Vector2(242, 350);
				"Computer":
					return Vector2(490, 18)
				_: 
					return Vector2(242, 350);
# 	CENA ATUAL: WORLD
		"World":
			match last_scene:
				"Cafeteria":
					return Vector2(1325, 29);
				_:
					return Vector2(1325, 29);
	
