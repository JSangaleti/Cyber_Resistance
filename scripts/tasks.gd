extends Control

func _ready() -> void:
	# Inicializa as tarefas no 'TasksManager.tasks'
	# e garante que cada uma tenha a chave "completed" = false
	for task in TasksManager.tasks:
		if not task.has("completed"):
			task["completed"] = false

# Sinais de conclusão de tarefas (exemplo)
func _task_01():
	TasksManager.set_task_status("task_1", "completed")

func _task_02():
	TasksManager.set_task_status("task_2", "completed")

func _task_03():
	TasksManager.set_task_status("task_3", "completed")
