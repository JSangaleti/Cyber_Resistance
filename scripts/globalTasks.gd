extends Node2D

# Tarefas e estado
var tasks: Array = []
var completed_tasks: Array = []  # Controla o estado de conclusão de cada missão
var number_level: int = 0 # Para a verificação do Level e acesso correto do arquivo json


func config_task_file(tasks: Array) -> void:
	#	Carregando o arquivo de tarefas aqui; Arquivo usado em Taks.gd
#	Tasks -------------------------------------------------------
	#var level : String = str(number_level) 
	#tasks = Global.load_json("res://assets/dialogs/tasks/level" + level + ".json") 
	#
	completed_tasks = []
	for task in tasks:
		if not task.has("concluida"):
			task["concluida"] = false
		completed_tasks.append(task["concluida"])
#	Fim Tasks ---------------------------------------------------

func check_task_level(tasks: Array):
	while true:
		var level : String = str(number_level) 
		tasks = Global.load_json("res://assets/dialogs/tasks/level" + level + ".json")
		
		for task in tasks:
			if task["concluida"] == false:
				return tasks # Se alguma não estiver concluída, então retorna o array tasks, que está correto.
		
		print("Level concluido")
		# Se não retornou, então todas estão concluídas. Próiximo level: 
		number_level = number_level + 1
	
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
	
