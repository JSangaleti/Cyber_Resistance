extends CanvasLayer

@onready var dialogue_panel: PanelContainer = $DialoguePanel
@onready var portrait: TextureRect = $DialoguePanel/MarginContainer/VBoxContainer/HBoxContainer/Portrait
@onready var name_label: Label = $DialoguePanel/MarginContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var text_label: Label = $DialoguePanel/MarginContainer/VBoxContainer/TextLabel
@onready var next_button: Button = $DialoguePanel/NextButton

# Array que guarda as falas atuais
var _dialogue_lines: Array = []
# Índice da fala atual
var _current_index: int = 0
# Armazena o npc_id ou qualquer identificador, caso precise
var _current_npc_id: String = ""

func _ready() -> void:
	hide()

# ---------------------------------------------------
# Inicia (ou abre) o diálogo com base em um array de falas
# Ex: [ {"id":"intro_1","text":"Olá","conditions":...,"used":false}, ... ]
# ---------------------------------------------------
func open_dialogue(dialogue_array: Array, npc_name: String, npc_id: String = "", portrait_path: String = "") -> void:
	if dialogue_array.size() == 0:
		return

	_dialogue_lines = dialogue_array
	_current_index = 0
	_current_npc_id = npc_id
	name_label.text = npc_name

	# Se tiver um portrait_path válido, carrega a imagem
	if portrait_path != "":
		portrait.texture = load(portrait_path)

	_show_line(_dialogue_lines[_current_index])
	show()

# Exibe uma linha específica do diálogo
func _show_line(dialogue_line: Dictionary) -> void:
	# Se tiver "portrait_path" no Dictionary, pode carregar
	# if dialogue_line.has("portrait_path"):
	#     portrait.texture = load(dialogue_line["portrait_path"])

	text_label.text = dialogue_line.get("text", "...")

func _on_next_button_pressed() -> void:
	_current_index += 1

	if _current_index >= _dialogue_lines.size():
		_close_dialogue()
		return

	_show_line(_dialogue_lines[_current_index])

# Fecha a interface de diálogo
func _close_dialogue() -> void:
	hide()

	# Exemplo: marcar diálogos 'once' como usados
	# (Você também pode fazer isso ao exibir cada linha.)
	for line in _dialogue_lines:
		if line["conditions"].get("once", false):
			DialogueManager1.mark_dialogue_used(_current_npc_id, line["id"])

	_dialogue_lines.clear()
	_current_index = 0
	_current_npc_id = ""
