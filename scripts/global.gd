extends Node2D


#Variável para identificar de que Cena o personagem veio. 
#Será usada para auxiliar com o Posicionamento do player após passar por uma transição de cenas. 
#var from_scene
##Variável criada com o intuito de retirar o erro de precisar de uma position na Cena Computador. 
##Com essa variável, é possível verificar em que cena está e então, se estiver na cena Computador, ignorará a Position
#var cena : String
#var cena_anterior : String = ""

#Cena atual e última cena visitada
var actual_scene : StringName = "MainMenuScreen" #é sempre a primeira cena.
var last_scene : StringName = ""

#Moedas - Dados globais d ojogo
var coins : int = 0

##Variável para identificar se o Player está em uma Missão
#var missao_ativa : bool
#var nome_missao : String

#Sobre diálogos específicos e essenciais na história do jogo.
var dialogo_especifico : String = ""
var dialogos_executados : Array = []

#Nas configurações do projeto, esta cena foi adicionada como Global. Contudo, todas as variáveis e funções
#aqui incluídas, poderão ser acessadas de qualquer cena ou nó do projeto. 

var interactions_scene = preload("res://scenes/interactions.tscn")
var interactions_instance = null
var mission_states = []

# QUIZ
var questions: Array = []

signal disable_painel

func _ready():
#	Dialogs - QUIZ.gd -------------------------------------------
	questions = load_json("res://assets/dialogs/quiz/quiz01.json")
	

func update_scene(actual: StringName) -> void:
	last_scene = actual_scene
	actual_scene = actual
	Interactions.update_interactions_painel();
	
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
					
					
#func read_json(source):
	## Lê o arquivo JSON com as tarefas
	#var file = FileAccess.open(source, FileAccess.READ)
	#if file:  # Certifique-se de que o arquivo foi lido com sucesso
		#return JSON.parse_string(file.get_as_text())
#
	#else:
		#print("Arquivo de tarefas não encontrado!")
		
# Método para carregar o JSON

# Carregar JSON com as tarefas
func load_json(filepath: String) -> Array:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text())
	else:
		print("Erro ao carregar o JSON de tarefas!")
		return []
