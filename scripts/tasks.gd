class_name Tasks
extends Control

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
