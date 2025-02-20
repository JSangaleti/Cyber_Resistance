extends Control

@export_file("*.json") var file_dialog: String = ""

var dialogs: Array = []
var id_current_dialog: int = 0
var active_dialog: bool = false

signal finish_dialog

func _ready() -> void:
	$NinePatchRect.visible = false
	load_dialogs()

func load_dialogs() -> void:
	if file_dialog == "":
		print("Arquivo de diálogo não especificado!")
		return
	# Certifique-se de que o caminho do arquivo é acessível
	if !FileAccess.file_exists(file_dialog):
		print("Arquivo de diálogo não encontrado:", file_dialog)
		return

	var file := FileAccess.open(file_dialog, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if result.error == OK:
			dialogs = result.result
			print("Diálogos carregados com sucesso!")
		else:
			print("Erro ao carregar o JSON:", result.error_message)

func dialog_start() -> void:
#	Se o diálogo já estiver ativo...
	if active_dialog:
		return
	active_dialog = true
	$NinePatchRect.visible = true
	id_current_dialog = -1
	next_dialog()

func next_dialog() -> void:
	id_current_dialog += 1
	if id_current_dialog >= dialogs.size():
		finalizar_dialog()
		return
	var dialog = dialogs[id_current_dialog]
	update_interface(dialog)

func update_interface(dialog: Dictionary) -> void:
	$NinePatchRect/Name.text = dialog.get("name", "Desconhecido")
	$NinePatchRect/Text.text = dialog.get("text", "")

func finalizar_dialog() -> void:
	active_dialog = false
	$NinePatchRect.visible = false
	emit_signal("finish_dialog")

func _input(event: InputEvent) -> void:
	if active_dialog and event.is_action_pressed("ui_accept"):
		next_dialog()

func _on_npc_quest_dialog_de_missao() -> void:
	dialog_start()
