extends Panel

@export_file("*.json") var file_dialog: String = ""
var tasks: Array = []  # Lista de tarefas carregadas do JSON (retornadas pelo TasksManager)

func _ready():
	# Carrega ou atualiza a lista de tarefas do nível atual.
	# Se seu TasksManager tem um método que retorna `tasks`,
	# use-o aqui. Exemplo:
	tasks = TasksManager.check_task_level()
	print("tasks: ", tasks)
	atualizar_lista_de_tarefas()

func atualizar_lista_de_tarefas():
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
	
	# Atualizar estado dos botões ao criar a interface
	atualizar_estado_dos_botoes()


func _on_task_button_pressed(task_button: Button):
	var description_label = task_button.get_meta("description_label") as Label
	var claim_reward_button = task_button.get_meta("claim_reward_button") as Button
	
	# Alternar visibilidade
	description_label.visible = not description_label.visible
	claim_reward_button.visible = description_label.visible

func _on_claim_reward_button_pressed(claim_reward_button: Button, task: Dictionary, task_index: int):
	# Agora, verificamos "completed" e "claimed"
	if task.has("completed") and task.has("claimed"):
		if task["completed"] and not task["claimed"]:
			task["claimed"] = true
			Global.coins += task.get("reward", 0)
			$"../LbCoins".text = str(Global.coins)
			
			print("Recompensa recebida para: ", task["title"], " | Valor: ", task["reward"])
			
			# Atualizar a lista de tarefas
			atualizar_estado_dos_botoes()
			atualizar_lista_de_tarefas()
		else:
			print("Erro: Tarefa não concluída ou recompensa já resgatada!")
	else:
		print("Erro: Tarefa sem campos 'completed' ou 'claimed'!")

func atualizar_estado_dos_botoes():
	var task_list = $TaskList.get_children()

	# Iterar sobre os botões e atualizar o estado conforme a tarefa
	for child in task_list:
		if child is Button:
			var task = child.get_meta("task") if child.has_meta("task") else null
			var index = child.get_meta("index") if child.has_meta("index") else null
			
			if task and index != null:
				# Se a tarefa já está 'completed' e 'claimed'
				if task["completed"] and task["claimed"]:
					if not child.disabled:
						child.disabled = true
						child.text = str(task["title"]) + " (Concluída)"
				# Se a tarefa está 'completed' mas não 'claimed'
				elif task["completed"] and not task["claimed"]:
					var description_label = child.get_meta("description_label") as Label
					var claim_reward_button = child.get_meta("claim_reward_button") as Button
					description_label.visible = true
					claim_reward_button.visible = true
					claim_reward_button.disabled = false
				else:
					# Tarefa não concluída
					child.disabled = false
