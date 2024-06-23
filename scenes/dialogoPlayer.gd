extends Control

signal dialogo_acabou

@export_file("*.json") var dialogo_file

var dialogo = []
var id_dialogo = 0
var dialogo_ativo = false

func _ready():
	$NinePatchRect.visible = false


func start():
	print("Diálogo iniciado")
	if dialogo_ativo:
		return
	dialogo_ativo = true
	$NinePatchRect.visible = true
	dialogo = carregar_dialogo()
	id_dialogo = -1
	proxima_fala()
	
func carregar_dialogo():
	var file = FileAccess.open("res://dialogo/dialogo_01.json", FileAccess.READ)
	var conteudo = JSON.parse_string(file.get_as_text())
	return conteudo
	
func _input(event):
	if !dialogo_ativo:
		return
	
	if event.is_action_pressed("Enter"):
		proxima_fala()
	
func proxima_fala():
	id_dialogo += 1
# Se o id for maior que o tamanho do array dialogo....
	if id_dialogo >= len(dialogo):
		dialogo_ativo = false
		$NinePatchRect.visible = false
		#Emitindo sinal pro Signal criado no início do script. Indica que o diálogo chegou ao fim
		emit_signal("dialogo_acabou")
		return
	$NinePatchRect/Name.text = dialogo[id_dialogo]['name']
	$NinePatchRect/Text.text = dialogo[id_dialogo]['text']
	
