extends Panel

@export_file("*.json") var file_dialog: String = ""
var tasks: Array = []  # Lista de tarefas carregadas do JSON (retornadas pelo TasksManager)

func _ready() -> void:
	tasks = TasksManager.check_task_level()
	update_task_list()
	
	# Conecta ao script tasks.gd, que emite "tasks_updated"
	var tasks_node = get_node("res://scenes/tasks.tscn") 

	if tasks_node:
		tasks_node.connect("tasks_updated", Callable(self, "_on_tasks_updated"))
	else:
		print_debug("Não foi possível encontrar o nó tasks.gd no caminho informado!")

func _on_tasks_updated():
	# Quando receber o sinal, recarrega as tasks do TasksManager
	tasks = TasksManager.check_task_level()
	update_task_list()
	#update_button_state()


func update_task_list() -> void:
	var task_list = $TaskList

	# Remove filhos existentes antes de adicionar novos
	for child in task_list.get_children():
		child.queue_free()

	# Criar interface dinâmica para cada tarefa
	for i in range(tasks.size()):
		var task = tasks[i]
			
		# Garante que task é um dicionário antes de acessar as chaves
		if typeof(task) != TYPE_DICTIONARY:
			print_debug("Erro: Formato inválido da tarefa:", task)
			continue

		# Criar os elementos da UI
		var task_button: Button = Button.new()
		var description_label: Label = Label.new()
		var claim_reward_button: Button = Button.new()
		
		# Definir estilos (cores, bordas, etc.)
		var task_style = StyleBoxFlat.new()
		task_style.bg_color = Color("#be772b")
		task_style.corner_radius_top_left = 10
		task_style.corner_radius_top_right = 10
		task_style.corner_radius_bottom_left = 10
		task_style.corner_radius_bottom_right = 10
		task_button.add_theme_stylebox_override("normal", task_style)
		task_button.add_theme_stylebox_override("hover", task_style)
		task_button.add_theme_stylebox_override("pressed", task_style)
		task_button.add_theme_color_override("font_color", Color("#341c27"))
		task_button.clip_contents = true
		
		var reward_style = StyleBoxFlat.new()
		reward_style.bg_color = Color("#cf573c")
		reward_style.border_color = Color("#a53030")
		reward_style.corner_radius_top_left = 10
		reward_style.corner_radius_top_right = 10
		reward_style.corner_radius_bottom_left = 10
		reward_style.corner_radius_bottom_right = 10
		claim_reward_button.add_theme_stylebox_override("normal", reward_style)
		claim_reward_button.add_theme_stylebox_override("hover", reward_style)
		claim_reward_button.add_theme_stylebox_override("pressed", reward_style)
		claim_reward_button.add_theme_color_override("font_color", Color("#e7d5b3"))
		claim_reward_button.clip_contents = true
		
		description_label.add_theme_color_override("font_color", Color("#e7d5b3"))
		description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Garante que os valores não estão vazios
		var task_title = task.get("title", "").strip_edges()
		var task_description = task.get("description", "").strip_edges()
		
		description_label.add_theme_font_size_override("Heveltica", 8)
		
		task_button.set_meta("task_id", task.get("id", ""))
		claim_reward_button.set_meta("task_id", task.get("id", ""))

		
		if task_title.is_empty():
			task_title = "Tarefa Sem Título"
		if task_description.is_empty():
			task_description = "Sem descrição"

		task_button.text = task_title
		description_label.text = task_description
		claim_reward_button.text = "Receber Recompensa"
		description_label.visible = false
		claim_reward_button.visible = false

		# Adicionar metadados
		task_button.set_meta("task", task)
		task_button.set_meta("description_label", description_label)
		task_button.set_meta("claim_reward_button", claim_reward_button)
		task_button.set_meta("index", i)
		
		claim_reward_button.set_meta("task", task)
		claim_reward_button.set_meta("index", i)

		# Adicionar os elementos ao contêiner
		task_list.add_child(task_button)
		task_list.add_child(description_label)
		task_list.add_child(claim_reward_button)

		# Conectar os sinais
		task_button.pressed.connect(_on_task_button_pressed.bind(task_button))
		claim_reward_button.pressed.connect(_on_claim_reward_button_pressed.bind(claim_reward_button, task, i))
	
		var completed = task.get("completed", false)
		var claimed = task.get("claimed", false)
		var task_status = task.get("status", "not_started")

		if completed and claimed:
			task_button.disabled = true
			task_button.text = task_title + " (OK)"
		elif completed and not claimed:
			task_button.disabled = false
			description_label.visible = true
			claim_reward_button.visible = true
			claim_reward_button.disabled = false
		elif task_status == "in_progress":
			task_button.disabled = false
		else:
			task_button.disabled = true


func _on_task_button_pressed(task_button: Button) -> void:
	var description_label = task_button.get_meta("description_label") as Label
	var claim_reward_button = task_button.get_meta("claim_reward_button") as Button
	
	# Alternar visibilidade
	description_label.visible = not description_label.visible
	claim_reward_button.visible = description_label.visible

func _on_claim_reward_button_pressed(claim_reward_button: Button, task: Dictionary, task_index: int):
	# 1) Puxar a lista mais recente do TasksManager (Isso é necessário para que 
	# a lista seja atualizada. Quando a missão é marcada como concluída no tasks.gd, 
	# aqui não é automaticamente atualizado. Então essa é a solução:
	tasks = TasksManager.check_task_level()

	# 2) Pegar a task correspondente ao index atual
	#var updated_task: Dictionary = tasks[task_index]
	var task_id = claim_reward_button.get_meta("task_id")
	var updated_task: Dictionary = TasksManager.get_task_by_id(task_id)


	# 3) Checar se 'completed' e 'claimed'
	if updated_task["completed"] and not updated_task["claimed"]:
		updated_task["claimed"] = true
		Global.coins += updated_task.get("reward", 0)
		$"../LbCoins".text = str(Global.coins)
		print("Recompensa recebida para:", updated_task["title"], "| Valor:", updated_task["reward"])
		
		# Atualiza UI
		#update_button_state()
		update_task_list()
	else:
		print("Erro: Tarefa não concluída ou recompensa já resgatada!")

#func update_button_state() -> void:
	#var task_list = $TaskList.get_children()
#
	#for child in task_list:
		#if child is Button:
			#var task = child.get_meta("task") if child.has_meta("task") else null
			#var index = child.get_meta("index") if child.has_meta("index") else null
			#
			#if task and index != null:
				#var task_status = task.get("status", "not_started")
				#var completed = task.get("completed", false)
				#var claimed = task.get("claimed", false)
#
				## --- 1) Se a missão anterior não foi reclamada, desabilitar a atual ---
				#if index > 0:
					#var prev_task = tasks[index - 1]
					## Se a missão anterior não estiver 'claimed', desabilita esta
					#if not prev_task["claimed"]:
						#child.disabled = true
						#continue  # Já pula o resto da lógica
#
				## --- 2) Lógica normal de ver se a tarefa atual está 'completed' e 'claimed' ---
				#if completed and claimed:
					## Botão desativado e texto '(Concluída)'
					#child.disabled = true
					#child.text = str(task["title"]) + " (Concluída)"
					#child.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
					#
				#elif completed and not claimed:
					## Missão concluída mas não reclamada => habilita o botão de recompensa
					#child.disabled = false
					#var description_label = child.get_meta("description_label") as Label
					#var claim_reward_button = child.get_meta("claim_reward_button") as Button
					#description_label.visible = true
					#claim_reward_button.visible =  	true
					#claim_reward_button.disabled = false
				#else:
					## Missão não concluída => Se estiver 'in_progress', deixa livre; se 'not_started', pode decidir se habilita ou não
					#if task_status == "in_progress":
						#child.disabled = false
					#else:
						## Exemplo: se 'not_started' ou outro estado, desativa
						#child.disabled = true
