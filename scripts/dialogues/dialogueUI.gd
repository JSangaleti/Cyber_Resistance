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

# Variáveis para o efeito de digitação
var _full_text: String = ""
var _current_text: String = ""
var _char_index: int = 0
var _typing_speed: float = 0.05  # Tempo entre cada caractere
var _time_accumulated: float = 0.0

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

	#text_label.text = dialogue_line.get("text", "...")
	_full_text = dialogue_line.get("text", "")
	_current_text = ""
	_char_index = 0
	_time_accumulated = 0.0
	text_label.text = ""

	# Ativa o _process() para animar a digitação
	set_process(true)

func _process(delta: float) -> void:
		# Acumula tempo
	_time_accumulated += delta

	# Se já exibimos tudo, parar de digitar
	if _char_index >= _full_text.length():
		set_process(false)
		return

	# Se passou o tempo suficiente, digita o próximo caractere
	if _time_accumulated >= _typing_speed:
		_time_accumulated = 0.0  # Zera para contar novamente
		_current_text += _full_text[_char_index]
		text_label.text = _current_text
		_char_index += 1
	

func _on_next_button_pressed() -> void:
	# Se ainda não terminamos de digitar a fala atual,
	# podemos "pular" a animação, mostrando o texto inteiro de uma vez:
	if _char_index < _full_text.length():
		_current_text = _full_text
		text_label.text = _full_text
		_char_index = _full_text.length()
		set_process(false)
		return

	# Se chegamos aqui, significa que a fala atual já foi exibida por completo
	_current_index += 1
	if _current_index >= _dialogue_lines.size():
		_close_dialogue()
	else:
		_show_line(_dialogue_lines[_current_index])

# Fecha a interface de diálogo
func _close_dialogue() -> void:
	hide()
	set_process(false) # Importante parar de rodar em segundo plano :)

	# Exemplo: marcar diálogos 'once' como usados
	# (Você também pode fazer isso ao exibir cada linha.)
	for line in _dialogue_lines:
		if line["conditions"].get("once", false):
			DialogueManager.mark_dialogue_used(_current_npc_id, line["id"])

	_dialogue_lines.clear()
	_current_index = 0
	_current_npc_id = ""
