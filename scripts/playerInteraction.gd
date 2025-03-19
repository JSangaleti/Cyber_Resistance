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
	# Verifica se temos um NPC válido
	if current_npc == null:
		print_debug("Nenhum NPC para interagir!")
		return
	
	# Verifica se o NPC possui um identificador (por exemplo, "npc_id")
	# Você pode guardar esse 'npc_id' no script do NPC ou usar meta:
	# current_npc.set_meta("npc_id", "ravi"), etc.
	
	if not current_npc.has_meta("npc_id"):
		print_debug("NPC sem 'npc_id'. Não é possível buscar diálogos.")
		return
	
	var npc_id: String = current_npc.get_meta("npc_id")
	
	# Pede ao DialogueManager (autoload) um diálogo para este NPC
	var chosen_dialogue: Dictionary = DialogueManager1.pick_dialogue(npc_id)
	var text: String = chosen_dialogue.get("text", "Nada a dizer...")

	# Exibe o texto na tela (você pode chamar um método do seu UI)
	_mostrar_texto_na_ui(text)

	# Se o diálogo for 'once', marca como usado
	if chosen_dialogue.get("conditions", {}).get("once", false):
		DialogueManager1.mark_dialogue_used(npc_id, chosen_dialogue["id"])

# Exemplo simples de mostrar texto na UI
# Substitua pela sua lógica de interface de diálogo
func _mostrar_texto_na_ui(texto: String) -> void:
	print_debug("Exibindo diálogo: ", texto)
	# Se tiver um painel de diálogo, algo como:
	# $DialogUI.show_text(texto)

# Esses métodos devem ser conectados aos sinais do Area2D
# para saber quando o Player está na zona de conversa
func _on_chat_detector_body_entered(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = true
		current_npc = body

func _on_chat_detector_body_exited(body: Node) -> void:
	if body.is_in_group("NPC"):
		can_interact = false
		current_npc = null
