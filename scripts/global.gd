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
var questions_data: Array = [] # Guardar todo o banco de questões
var questions: Array = [] # Guardar apenas as questões que serão mostradas

# Gerenciar o movimento do personagem durante as interações com NPC
var is_talking : bool = false

signal disable_painel

func _ready():
	randomize()
#	Dialogs - QUIZ.gd -------------------------------------------
# Caminho: "res://assets/dialogs/quiz/quiz01.json"

# --------------------- Provisóriamente.... depois corrigir e deixar certinho em cada script
	questions_data = load_json("res://assets/dialogs/quiz/quiz01.json")
	# Embaralha as questões finais
	questions_data.shuffle()
	
	var temas_desejados = {
		"Senhas": 2,
		"Cibersegurança": 2,
		"Redes": 2
	}
	
	questions = filtrar_questoes_por_tema(questions_data, temas_desejados)
# --------------------------------------------------------------------------------	
#func _ready():
	#var todas_questoes = load_json("res://assets/dialogs/quiz/quiz01.json")
#
	##var temas_desejados = {
		##"Senhas": 2,
		##"Cibersegurança": 2,
		##"Redes": 2
	##}
#
	#questions = []
#
	#for tema in temas_desejados.keys():
		#var qtd = temas_desejados[tema]
		#var questoes_tema = todas_questoes.filter(func(q): return q.has("assunto") and q["assunto"] == tema)
		#questoes_tema.shuffle()
		#var selecionadas = questoes_tema.slice(0, qtd)
		#questions.append_array(selecionadas)
#
	#questions.shuffle()
	#print("QUESTIONS:::::::::::::::::::::::")
	#for q in questions:
		#print(q.get("assunto", "SEM ASSUNTO"), "::", q.get("texto", ""))

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
				"University":
					return Vector2(1603.0, -330);
				_:
					return Vector2(1600, 162);
		"University":
			match last_scene:
				"World":
					return Vector2(376, 497);
				_:
					return Vector2(376, 497);
					
					
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
func load_json(filepath: String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text())
	else:
		print("Erro ao carregar o JSON de tarefas!")
		return []

# Carregar Questões por TEMA
func load_questions_by_theme(path: String, tema_quantidades: Dictionary) -> Array:
	var todas = load_json(path)
	var selecionadas = []

	for tema in tema_quantidades.keys():
		var filtradas = todas.filter(func(q): return q.has("assunto") and q.tema == tema)
		filtradas.shuffle()
		selecionadas.append_array(filtradas.slice(0, tema_quantidades[tema]))
	
	selecionadas.shuffle()
	return selecionadas
	
func filtrar_questoes_por_tema(questoes: Array, quantidade_por_tema: Dictionary) -> Array:
	var selecionadas: Array = []
	var usadas_ids: Dictionary = {}  # Para evitar repetição de questões

	for tema in quantidade_por_tema.keys():
		var qtd = quantidade_por_tema[tema] # quantidade de cada tema
		var questoes_tema = questoes.filter(func(q): return q.has("assunto") and q["assunto"] == tema) # array com as questões que são apenas daquele tema

		questoes_tema.shuffle()

		var contador_tema = 0 # quant de questões do tema que já foram selecionadas
		for q in questoes_tema:
			if contador_tema >= qtd: 
				break
			if not usadas_ids.has(q["id"]): # pra não repetir questões no quiz
				selecionadas.append(q)
				usadas_ids[q["id"]] = true
				contador_tema += 1
		
	return selecionadas
