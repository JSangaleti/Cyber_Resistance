extends Control

signal dialogo_missao_acabou

@export_file("*.json") var dialogo_missao_file

var dialogo_missao = []
var id_dialogo_missao = 0
var dialogo_missao_ativo = false
var primeiro_dialogo_missao = false

func _ready():
	$NinePatchRect.visible = false


func start():
	print("Diálogo iniciado")
	if dialogo_missao_ativo:
		return
	dialogo_missao_ativo = true
	$NinePatchRect.visible = true
	dialogo_missao = carregar_dialogo_missao()
	id_dialogo_missao = -1
	proxima_fala()
	
func carregar_dialogo_missao():
	print("entrou em carregar dialogo_missao")
	
	if Global.dialogo_especifico != "":
		var file = FileAccess.open("res://dialogo/"+ Global.dialogo_especifico +".json", FileAccess.READ)
		var conteudo = JSON.parse_string(file.get_as_text())
			
		return conteudo
	
func _input(event):
	if !dialogo_missao_ativo:
		return
	
	if event.is_action_pressed("Enter"):
		#Tocando efeito sonoro
		ControleMusica.clique_simples()
		proxima_fala()
	
func proxima_fala():
	id_dialogo_missao += 1
# Se o id for maior que o tamanho do array dialogo_missao....
	if id_dialogo_missao >= len(dialogo_missao):
		dialogo_missao_ativo = false
		$NinePatchRect.visible = false
		#Emitindo sinal pro Signal criado no início do script. Indica que o diálogo chegou ao fim
		emit_signal("dialogo_missao_acabou")
		return
	$NinePatchRect/Name.text = dialogo_missao[id_dialogo_missao]['name']
	$NinePatchRect/Text.text = dialogo_missao[id_dialogo_missao]['text']
	
func escolher(array):
	array.shuffle()
	return array.front()

func _on_npc_quest_dialogo_de_missao():
	start()
