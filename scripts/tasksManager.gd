extends Node2D

var tasks: Array = []         # Armazena as tarefas do level atual
var number_level: int = 0     # Nível atual

func _ready() -> void:
	# Carrega as tarefas do level atual na inicialização
	load_level_tasks(number_level)

# ----------------------------------------------------
# Carrega o arquivo JSON do level e inicializa as tarefas
# ----------------------------------------------------
func load_level_tasks(level: int) -> void:
	var path = "res://assets/dialogs/tasks/level%d.json" % level
	var data = Global.load_json(path)  # ou FileAccess.open + parse manual
	if data.is_empty():
		print_debug("Arquivo de tarefas vazio ou inexistente:", path)
		return
	
	# data = { "level_id": 0, "tasks": [ {...}, {...} ] }
	tasks = data.get("tasks", [])
	
	# Atualiza o status local (ex.: completed, claimed, etc.)
	for t in tasks:
		if not t.has("status"):
			t["status"] = "not_started"
		if not t.has("completed"):
			t["completed"] = false
		if not t.has("claimed"):
			t["claimed"] = false

	print_debug("Carregadas", tasks.size(), "tarefas do level", level)

# ----------------------------------------------------
# Marca uma tarefa como "in_progress" ou "completed", etc.
# ----------------------------------------------------
func set_task_status(task_id: String, new_status: String) -> void:
	for t in tasks:
		# Primeiro, verifica se t é mesmo um dicionário
		if t is Dictionary:
			# Depois, veja se existe a chave "id"
			if t.has("id") and t["id"] == task_id:
				t["status"] = new_status
				if new_status == "completed":
					t["completed"] = true
				break
		else:
			print_debug("Elemento de 'tasks' não é Dictionary:", t)

# ----------------------------------------------------
# Retorna o status de uma tarefa
# ----------------------------------------------------
func get_task_status(task_id: String) -> String:
	for t in tasks:
		if t is Dictionary:
			if  t.has("id") and t["id"] == task_id:
				return t["status"]
	return "not_found"

# ----------------------------------------------------
# Verifica se todas as tarefas do level atual foram concluídas
# ----------------------------------------------------
func is_level_completed() -> bool:
	for t in tasks:
		if t is Dictionary:
			if  t.has("id") and not t["completed"]:
				return false
	return true

# ----------------------------------------------------
# Avança para o próximo level, se todas as tarefas do atual estiverem completas
# ----------------------------------------------------
func check_task_level() -> Array:
	if is_level_completed():
		number_level += 1
		load_level_tasks(number_level)
		print_debug("Level concluído! Agora no level", number_level)
	else:
		print_debug("Ainda há tarefas pendentes no level", number_level)
	return tasks  # Retorna as tarefas atuais
