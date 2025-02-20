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

# Tarefas e estado
var tasks: Array = []
var completed_tasks: Array = []  # Controla o estado de conclusão de cada missão

#Variável para identificar se o Player está em uma Missão
var missao_ativa : bool
var nome_missao : String

#Sobre diálogos específicos e essenciais na história do jogo.
var dialogo_especifico : String = ""
var dialogos_executados : Array = []

#Nas configurações do projeto, esta cena foi adicionada como Global. Contudo, todas as variáveis e funções
#aqui incluídas, poderão ser acessadas de qualquer cena ou nó do projeto. 

var interactions_scene = preload("res://scenes/interactions.tscn")
var interactions_instance = null
var mission_states = []

signal disable_painel

func _ready():
#	Carregando o arquivo aqui.
	tasks = load_json("res://assets/dialogs/tasks/tasks01.json") 
	completed_tasks = []
	for task in tasks:
		if not task.has("concluida"):
			task["concluida"] = false
		completed_tasks.append(task["concluida"])
		
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

# Atualiza a lista de tarefas (pode ser chamado quando o jogo inicia)
func update_tasks(new_tasks: Array) -> void:
	tasks = new_tasks
	# Inicialize o array de tarefas concluídas (um valor booleano para cada tarefa)
	completed_tasks = []
	for task in tasks:
		# Se a tarefa já tiver a chave "concluida", use-a; caso contrário, inicialize como false
		if task.has("concluida"):
			completed_tasks.append(task["concluida"])
		else:
			task["concluida"] = false
			completed_tasks.append(false)
