extends Control

signal finish_task(title)

func _ready() -> void:
	# Carregar tarefas do JSON e inicializar missões concluídas
	#Global.tasks = Global.load_json("res://assets/dialogs/tasks/tasks01.json")
	#Global.completed_tasks = []
#	 ATUALIZAÇÃO: AGORA O ARQUIVO É CARREGADO EM GLOBAL.GD	

	for task in Global.tasks:
		# Certifique-se de que cada tarefa tenha a chave "concluida"
		if not task.has("concluida"):
			task["concluida"] = false
		
		Global.completed_tasks.append(task["concluida"])

# Exemplo de uma missão específica
func _task_01():
	# Missão com sinais sendo emitidos a partir do NPC. Sinal Talking_to_NPC
	# Verificar se a missão foi concluída
	if not Global.completed_tasks[0]:
		Global.completed_tasks[0] = true
		emit_signal("finish_task", Global.tasks[0]["titulo"])
	
func _task_02():
	# Missão de visitar a cafeteria
	if not Global.completed_tasks[1]:
		Global.completed_tasks[1] = true
		emit_signal("finish_task", Global.tasks[1]["titulo"])
		
func _task_03():
	# Missão para acessar o PC da cafeteria
	if not Global.completed_tasks[2]:
		Global.completed_tasks[2] = true
		emit_signal("finish_task", Global.tasks[2]["titulo"])
