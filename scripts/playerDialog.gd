extends Control

signal dialogo_acabou

@export_file("*.json") var dialogo_file

var dialogo = []
var id_dialogo : int = 0
var dialogo_ativo : bool = false

func _ready():
	$NinePatchRect.visible = false


func start():
	print("Diálogo iniciado")
	if dialogo_ativo:
		return
	dialogo_ativo = true
	$NinePatchRect.visible = true
	dialogo = carregar_dialogo()
	
	print("DIALOGO: ", dialogo)
	
	id_dialogo = -1
	proxima_fala()
	
func carregar_dialogo():
#	Primeiro roda o primeiro diálogo. Após isso, apenas os demais diálogo aleatórios
	if Global.dialogos_executados == []: 
		var file = FileAccess.open("res://dialogo/dialogo_01.json", FileAccess.READ)
		var conteudo = JSON.parse_string(file.get_as_text())
		Global.dialogos_executados = [1]
		return conteudo
	else:
		print("Escolhendo dialogo aleatório")
		var dialogo_aleatorio = escolher(["02", "03", "04"])
		
		var file = FileAccess.open("res://dialogo/dialogo_"+ dialogo_aleatorio +".json", FileAccess.READ)
		var conteudo = JSON.parse_string(file.get_as_text())
		return conteudo

	
func _input(event):
	if !dialogo_ativo:
		return
	
	if event.is_action_pressed("Enter"):
		#Tocando efeito sonoro
		ControleMusica.clique_simples()
		proxima_fala()
	
func proxima_fala():
	id_dialogo += 1
# Se o id for maior que o tamanho do array dialogo....
	if dialogo != []:
		if id_dialogo >= int(len(dialogo)):
			dialogo_ativo = false
			$NinePatchRect.visible = false
			#Emitindo sinal pro Signal criado no início do script. Indica que o diálogo chegou ao fim
			emit_signal("dialogo_acabou")
			return
	$NinePatchRect/Name.text = dialogo[id_dialogo]['name']
	$NinePatchRect/Text.text = dialogo[id_dialogo]['text']
	
func escolher(array):
	array.shuffle()
	return array.front()
