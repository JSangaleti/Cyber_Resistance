class_name Tasks
extends Control

signal quiz_open

func _ready() -> void:
	# Inicializa as tarefas no 'TasksManager.tasks'

	# e garante que cada uma tenha a chave "completed" = false
	for task in TasksManager.tasks:
		if not task.has("completed"):
			task["completed"] = false

# Sinais de conclusão de tarefas 
func _task_1():
	TasksManager.set_task_status("task_1", "completed")
	DialogueManager.set_task_state("task_1", "completed")
	
	TasksManager.set_task_status("task_2", "in_progress")
	
func _task_2():
	TasksManager.set_task_status("task_2", "completed")
	DialogueManager.set_task_state("task_2", "completed")
	
	TasksManager.set_task_status("task_3", "in_progress")

func _task_3():
	TasksManager.set_task_status("task_3", "completed")
	DialogueManager.set_task_state("task_3", "completed")
	
	TasksManager.set_task_status("task_4", "in_progress")

func _task_4():
	TasksManager.set_task_status("task_4", "completed")
	DialogueManager.set_task_state("task_4", "completed")
	
	TasksManager.set_task_status("task_5", "in_progress")
	
func _task_5():
	TasksManager.set_task_status("task_5", "completed")
	DialogueManager.set_task_state("task_5", "completed")
	
	#TasksManager.set_task_status("task_6", "in_progress")


# Para verificação de tasks
func _on_player_talking_to_npc(current_npc: Variant) -> void:
	# Para task_1: conversar com o NPC Ravi
	if TasksManager.get_task_status("task_1") == "in_progress":
		if current_npc.get_meta("npc_id") == "ravi" :
			await get_tree().create_timer(0.5).timeout
			_task_1()
	# Para a task_2: conversar com o NPC Hubner. Elif para evitar o processamento de todos os ifs. 
	elif TasksManager.get_task_status("task_2") == "in_progress":
		if current_npc.get_meta("npc_id") == "hubner" :
			await get_tree().create_timer(0.5).timeout
			_task_2()
	# Para a task_3: conversar com o NPC Bernadete. 
	elif TasksManager.get_task_status("task_3") == "in_progress":
		if current_npc.get_meta("npc_id") == "bernadete" :
			await get_tree().create_timer(0.5).timeout
			_task_3()

func _on_player_changed_scene(scene: Variant) -> void: # Sinal emitido pelo DoorArea
	pass

func _on_wifi_conected() -> void: # Conexão realizada no pc da Cafeteria
	if TasksManager.get_task_status("task_4") == "in_progress":
		await get_tree().create_timer(0.5).timeout
		_task_4()


func _on_finished_quiz(successes: Variant, mistakes: Variant) -> void: # Quiz finalizado
	if TasksManager.get_task_status("task_5") == "in_progress":
		# É possível utilizar as variáveis successes (quant de acertos) e mistakes (quant de erros),
		# mas não utilizarei nesta missão. 
		_task_5()
		
		
