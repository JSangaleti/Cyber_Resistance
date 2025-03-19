# Arquivo: DialogueManager.gd
# Classe responsável por gerenciar todos os diálogos do jogo.
# Pode ser usada como autoload (singleton) para ficar acessível de qualquer lugar.

class_name DialogueManager
extends Node

# Dicionário que armazena todos os diálogos carregados na memória, indexados pelo npc_id
var npc_data: Dictionary = {}  # Armazena portrait e diálogos

# Exemplo de dicionário para estados de missões (você pode mover isso para um "taskManager.gd")
var task_states: Dictionary = {
	# "seguranca_senhas": "in_progress",
	# ...
}

# Referência ao script de leitura (NPCDialogueLoader)
@onready var loader: NPCDialogueLoader = NPCDialogueLoader.new()

# Chamado quando o nó é adicionado à cena ou quando o jogo inicia (se for autoload)
func _ready() -> void:
	print_debug("DialogueManager pronto!")

# --------------------------------------------------
#  1. Carrega e Armazena Diálogos de um NPC
# --------------------------------------------------

func load_dialogues_for_npc(npc_id: String):
	var data = loader.load_npc_dialogues(npc_id)
	if data.is_empty():
		print_debug("Falha ao carregar JSON do NPC:", npc_id)
		return
	
	# data deve ter: {"npc_id":"hubner","portrait_path":"...","dialogues":[...]}
	npc_data[npc_id] = {
		"portrait_path": data.get("portrait_path", ""),
		"dialogues": data.get("dialogues", [])
	}
	print_debug("NPC", npc_id, "carregado com", npc_data[npc_id]["dialogues"].size(), "falas.")


func get_npc_portrait(npc_id: String) -> String:
	if npc_data.has(npc_id):
		return npc_data[npc_id]["portrait_path"]
	return ""

# --------------------------------------------------
#  2. Retorna todos os diálogos válidos para um NPC
# --------------------------------------------------
func get_valid_dialogues(npc_id: String) -> Array:
	# Se não carregamos ainda, tente carregar
	if not npc_data.has(npc_id):
		load_dialogues_for_npc(npc_id)
		if not npc_data.has(npc_id):
			return []
	
	var dialogues_array: Array = npc_data[npc_id]["dialogues"]
	var valid_dialogues: Array = []
	
	for d in dialogues_array:
		# Se for once e used=true, ignore
		if d["used"] == true and d["conditions"].get("once", false):
			continue
		
		# Verifica 'required_task' e 'task_status'
		if d["conditions"].has("required_task"):
			var req_task = d["conditions"]["required_task"]
			if req_task != null:
				var task_status_needed = d["conditions"].get("task_status", null)
				var current_task_state = task_states.get(req_task, null)
				
				if task_status_needed != null and current_task_state != task_status_needed:
					continue
		
		valid_dialogues.append(d)
	
	return valid_dialogues


# --------------------------------------------------
#  3. Escolhe (ou sorteia) um diálogo dentre os válidos
# --------------------------------------------------
func pick_dialogue(npc_id: String) -> Dictionary:
	var candidates = get_valid_dialogues(npc_id)
	if candidates.size() == 0:
		# Se não tiver nenhum, retorna um diálogo padrão
		return {
			"id": "fallback",
			"text": "Não tenho nada a dizer no momento.",
			"used": false,
			"conditions": {}
		}
	
	# Exemplo: escolha aleatória
	var index = randi() % candidates.size()
	return candidates[index]

# --------------------------------------------------
#  4. Marca um diálogo como "usado"
# --------------------------------------------------
func mark_dialogue_used(npc_id: String, dialogue_id: String) -> void:
	if not npc_data.has(npc_id):
		return
	var dialogues_array: Array = npc_data[npc_id]["dialogues"]
	
	for d in dialogues_array:
		if d["id"] == dialogue_id:
			d["used"] = true
			break
			
# --------------------------------------------------
#  5. Atualiza estado de missão (exemplo simples)
# --------------------------------------------------
func set_task_state(task_id: String, new_state: String) -> void:
	task_states[task_id] = new_state
	print_debug("Tasks:", task_id, "-> estado:", new_state)

# --------------------------------------------------
#  6. Verifica estado de missão (exemplo simples)
# --------------------------------------------------
func get_task_state(task_id: String) -> String:
	if task_states.has(task_id):
		return task_states[task_id]
	return "not_started"
