extends Control

#signal finish_task(title)

func _ready() -> void:
	# Carregar tarefas do JSON e inicializar missões concluídas
	#Global.tasks = Global.load_json("res://assets/dialogs/tasks/tasks01.json")
	#Global.completed_tasks = []
#	 ATUALIZAÇÃO: AGORA O ARQUIVO É CARREGADO EM GLOBAL.GD	

	for task in GlobalTasks.tasks:
		# Certifique-se de que cada tarefa tenha a chave "concluida"
		if not task.has("concluida"):
			task["concluida"] = false
		
		GlobalTasks.completed_tasks.append(task["concluida"])

# LEVEL 01 --------------------------------------------------------------------
func _task_01():
	# Missão com sinais sendo emitidos a partir do NPC. Sinal Talking_to_NPC
	# Verificar se a missão foi concluída
	if not GlobalTasks.completed_tasks[0]:
		GlobalTasks.completed_tasks[0] = true
		#emit_signal("finish_task", GlobalTasks.tasks[0]["titulo"])
	
func _task_02():
	# Missão de visitar a cafeteria
	if not GlobalTasks.completed_tasks[1]:
		GlobalTasks.completed_tasks[1] = true
		#emit_signal("finish_task", GlobalTasks.tasks[1]["titulo"])
		
func _task_03():
	# Missão para acessar o PC da cafeteria
	if not GlobalTasks.completed_tasks[2]:
		GlobalTasks.completed_tasks[2] = true
		#emit_signal("finish_task", GlobalTasks.tasks[2]["titulo"])
