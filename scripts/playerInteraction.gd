extends CharacterBody2D

# Variáveis para interação
var can_interact: bool = false
var current_npc: Node = null

func _process(delta: float) -> void:
	# Se podemos interagir e a tecla de diálogo foi pressionada
	if can_interact and Input.is_action_just_pressed("chat_accept"):
		_start_dialogue()

# Inicia o diálogo com o NPC atual
func _start_dialogue() -> void:
	if current_npc == null:
		print_debug("Nenhum NPC para interagir!")
		return

	# Verifica se o NPC possui um identificador (por exemplo, "npc_id")
	if not current_npc.has_meta("npc_id"):
		print_debug("NPC sem 'npc_id'. Não é possível buscar diálogos.")
		return
	
	var npc_id: String = current_npc.get_meta("npc_id")
	
	# 1) Obter TODAS as falas válidas para este NPC
	var dialogues_array: Array = DialogueManager1.get_valid_dialogues(npc_id)

	if dialogues_array.size() == 0:
		print_debug("Nenhum diálogo válido encontrado para NPC:", npc_id)
		return
		
	# Pegar o retrato (pode ser guardado no DialogueManager1 ou no script do NPC)
	var portrait_path: String = DialogueManager1.get_npc_portrait(npc_id)

	# 2) Obter o nome do NPC (opcional). Se quiser armazenar no NPC:
	var npc_name = "NPC"
	if current_npc.has_meta("npc_name"):
		npc_name = current_npc.get_meta("npc_name")

	# 3) Abrir a interface de diálogo
	#    DialogueUI é o script/cena de UI (CanvasLayer).
	DialogueUI.open_dialogue(dialogues_array, npc_name, npc_id, portrait_path)

func _on_chat_detector_body_entered(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = true
		current_npc = body

func _on_chat_detector_body_exited(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = false
		current_npc = null
