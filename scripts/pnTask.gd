extends Panel

@export_file("*.json") var file_dialog: String = ""
var tasks = []  # Lista de tarefas carregadas do JSON

func _ready():

	## Carregar tarefas no início do jogo
	#Global.check_task_level(Global.tasks) # Verificando o level correto a ser carregado
	#Global.load_task_file(Global.number_level)
	#
	
	tasks = GlobalTasks.check_task_level(GlobalTasks.tasks)
	GlobalTasks.config_task_file(tasks)
	atualizar_lista_de_tarefas()

	# Conectar ao sinal de tarefa concluída
	#var tasks_script = $"../../Tasks"
	#tasks_script.finish_task.connect(self._on_task_completed)

func atualizar_lista_de_tarefas():
	var task_list = $TaskList

	# Remove filhos existentes antes de adicionar novos
	for child in task_list.get_children():
		child.queue_free()

	# Criar interface dinâmica para cada tarefa
	for i in range(tasks.size()):
		var task = tasks[i]
		
		# Criar os elementos da UI
		var task_button: Button = Button.new()
		var description_label: Label = Label.new()
		var claim_reward_button: Button = Button.new()
		
		# Definir estilos
		var task_style = StyleBoxFlat.new()
		#be772b
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
		
		# Definir texto e estados
		task_button.text = task["titulo"]
		description_label.text = task["descricao"]
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
	description_label.visible = !description_label.visible
	claim_reward_button.visible = description_label.visible

func _on_claim_reward_button_pressed(claim_reward_button: Button, task: Dictionary, task_index: int):
	if GlobalTasks.completed_tasks[task_index] and not task["reclamada"]:
		task["reclamada"] = true
		Global.coins += task["recompensa"]
		$"../LbCoins".text = str(Global.coins)

		#Global.save_json("res://assets/dialogs/tasks/tasks01.json", Global.tasks)
		print("Recompensa recebida para: ", task["titulo"], " | Valor: ", task["recompensa"])

		# Atualizar a lista de tarefas
		atualizar_estado_dos_botoes()
		atualizar_lista_de_tarefas()
		
	else:
		print("Erro: Tarefa não concluída ou recompensa já resgatada!")

#func _on_task_completed(task_title: String):
	#print("Tarefa concluída: ", task_title)
	#atualizar_estado_dos_botoes()

func atualizar_estado_dos_botoes():
	var task_list = $TaskList.get_children()

	# Iterar sobre os botões e atualizar o estado conforme a tarefa
	for child in task_list:
		if child is Button:
			var task = child.get_meta("task") if child.has_meta("task") else null
			var index = child.get_meta("index") if child.has_meta("index") else null
			
			if task and index != null:
				# Verificar se a missão foi concluída e recompensa já resgatada
				if GlobalTasks.completed_tasks[index] and task["reclamada"]:
					# Garantir que o botão seja desativado apenas uma vez
					if not child.disabled: 
						child.disabled = true
						child.text = str(task["titulo"]) + " (Concluída)"
				elif GlobalTasks.completed_tasks[index] and not task["reclamada"]:
					# Caso a missão esteja concluída, mas recompensa ainda não foi resgatada
					var description_label = child.get_meta("description_label") as Label
					var claim_reward_button = child.get_meta("claim_reward_button") as Button
					description_label.visible = true
					claim_reward_button.visible = true
					claim_reward_button.disabled = false
				else:
					# Missão não concluída
					child.disabled = false
