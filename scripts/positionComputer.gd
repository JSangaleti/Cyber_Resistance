extends Node2D

@export var nextScene : String = ""
@onready var btTerminal = $BtTerminal

var mouse_entered := false

#Posições de cada tela
var home_pos : Vector2 = Vector2(0,0)
var setting_pos : Vector2 = Vector2(-1664,0)
var wifi_setting_pos : Vector2 = Vector2(-3136, 0)

# Variável para armazenar o overlay. Serve para bloquer a tela
var overlay: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().change_scene_to_file(nextScene)
	Global.update_scene("Computer")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_bt_terminal_pressed():
	get_tree().change_scene_to_file("res://scenes/controls/terminal.tscn")
	print("ok, deu certo")

# Botão Configuração, de Home para Setting (Configuração)
func _on_btConfig_pressed() -> void:
	$".".global_position = setting_pos

# Botão Wifi, de Setting para WifiSetting
func _on_btWifi_pressed() -> void:
	$".".global_position = wifi_setting_pos

# Botão Voltar, de Setting para Home
func _on_btBack_pressed() -> void:
	$".".global_position = home_pos

#Botão Voltar, de Wifi para Setting
func _on_btBackWifi_pressed() -> void:
	$".".global_position = setting_pos

# Wifi Setting, Botão para ativar e desativar wifi
func _on_btConnectWifi_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$WifiSetting/VBoxContainer.visible = true
	else:
		$WifiSetting/VBoxContainer.visible = false
		
# Botão Wifi da Cafeteria, privado; Ativar anagrama de palavras para senha
func _on_btCafeteriaWifi2_pressed() -> void:
	$AnagramWifi.visible = true
#	Bloqueando tela
	$WifiSetting/BtBackWifi.disabled = true
	$WifiSetting/BtConnectWifi.disabled = true
	
#	Ativando overlay para bloquear a tela
	overlay = ColorRect.new()
	overlay.color = Color(1, 1, 1, 0)  # Transparente
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP  # Bloqueia eventos de mouse
	overlay.size = $WifiSetting/VBoxContainer.size  # Ajusta o tamanho do overlay
	overlay.position = $WifiSetting/VBoxContainer.position  # Posiciona o overlay no canto superior esquerdo do pai
	
	$WifiSetting.add_child(overlay)  # Adiciona o overlay como filho do WifiSetting
# Botão Close da Janela do Anagrama para Senha do Wifi
func _on_btClose_pressed() -> void:
	$AnagramWifi.visible = false
	#	Desbloqueando tela 
	$WifiSetting/BtBackWifi.disabled = false
	$WifiSetting/BtConnectWifi.disabled = false
	$WifiSetting/VBoxContainer.visible = true
	
	# Remover o overlay
	if overlay:
		overlay.queue_free()  # Remove o overlay da cena
		overlay = null  # Limpa a referência

	
