extends Control

# Estrutura das questões e respostas
var questions: Array = []  # Certifique-se de que `Global.questions` está carregado corretamente

var id_question: int = 0  # Índice da questão atual
var acertos: int = 0  # Contador de acertos
var erros: int = 0  # Contador de erros

# Referências aos nós
@onready var label_questao: Label = $VBoxContainer/LbQuestion
@onready var option_button: OptionButton = $VBoxContainer/OpAlternatives
@onready var botao_enviar: Button = $VBoxContainer/BtCheck
@onready var label_feedback: Label = $VBoxContainer/LbFeedback
@onready var label_explicacao: Label = $VBoxContainer/LbExplanation
@onready var botao_proxima: Button = $VBoxContainer/BtNext
@onready var label_resultado_final: Label = $VBoxContainer/LbResult
@onready var botao_fechar: Button = $VBoxContainer/BtClose

func _ready() -> void:
	print("Quiz carregado!")  # Depuração
	visible = true  # Oculta o quiz inicialmente
	
	if Global.questions.size() > 0:
		questions = Global.questions.duplicate(true)
		embaralhar_questoes()
		aplicar_estilos()
		ajustar_interface()
		mostrar_questao()
		botao_proxima.visible = false
		label_resultado_final.visible = false
		botao_fechar.visible = false
	else:
		label_questao.text = "Nenhuma questão carregada."

func ajustar_interface() -> void:
	$VBoxContainer.custom_minimum_size.x = 600  # Largura fixa de 600 pixels
	for label in [label_questao, label_feedback, label_explicacao, label_resultado_final]:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func mostrar_questao() -> void:
	if id_question < 0 or id_question >= questions.size():
		return
	
	var questao: Dictionary = questions[id_question]
	label_questao.text = questao.get("texto", "")
	label_feedback.text = ""
	label_explicacao.add_theme_color_override("font_color", Color("341c27"))
	label_explicacao.text = ""
	option_button.clear()
	
	for alternativa in questao.get("alternativas", []):
		option_button.add_item(alternativa.get("texto", ""))
	
	botao_enviar.disabled = false
	botao_proxima.visible = false

func esconder_questao() -> void:
	label_feedback.text = ""
	label_explicacao.text = ""
	label_questao.text = ""
	option_button.clear()
	option_button.visible = false
	botao_enviar.disabled = false
	botao_proxima.visible = false

func verificar_resposta() -> void:
	var indice_selecionado: int = option_button.selected
	if indice_selecionado == -1:
		label_feedback.text = "Selecione uma alternativa!"
		return
	
	var questao: Dictionary = questions[id_question]
	var letra_selecionada: String = questao.get("alternativas", [])[indice_selecionado].get("letra", "")
	
	if letra_selecionada == questao.get("resposta_correta", ""):
		label_feedback.add_theme_color_override("font_color", Color("468232"))
		label_feedback.text = "Resposta correta!"
		acertos += 1
	else:
		label_feedback.add_theme_color_override("font_color", Color("a53030"))
		label_feedback.text = "Resposta incorreta."
		erros += 1
	
	label_explicacao.text = questao.get("explicacao", "")
	botao_enviar.disabled = true
	botao_proxima.visible = true

func proxima_questao() -> void:
	id_question += 1
	if id_question < questions.size() and id_question < 5:
		aplicar_estilos()
		mostrar_questao()
	else:
		esconder_questao()
		label_resultado_final.add_theme_color_override("font_color", Color("3c5e8b"))
		label_resultado_final.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_resultado_final.text = "Fim do Quiz!\nAcertos: %d\nErros: %d" % [acertos, erros]
		label_resultado_final.visible = true
		botao_fechar.visible = true
		botao_proxima.visible = false
		botao_enviar.visible = false

func embaralhar_questoes() -> void:
	questions.shuffle()

func aplicar_estilos() -> void:
	# Pegando o popup interno do OptionButton
	var popup = option_button.get_popup()

	# Criando estilo para os itens do menu suspenso
	var style_item := StyleBoxFlat.new()
	style_item.bg_color = Color("4d2b32") # Fundo dos itens
	style_item.border_color = Color("7a4841") # Borda dos itens
	style_item.border_width_left = 2
	style_item.border_width_right = 2
	style_item.border_width_top = 2
	style_item.border_width_bottom = 2

	# Aplicando estilos ao popup (menu suspenso)
	popup.add_theme_stylebox_override("panel", style_item)

	# Aplicando estilo aos itens do menu
	popup.add_theme_color_override("font_color", Color("e7d5b3"))
	popup.add_theme_color_override("font_color_hover", Color("d7b594"))

	
	# Criando estilo para o OptionButton
	var style_option_button := StyleBoxFlat.new()
	
	style_option_button.bg_color = Color("4d2b32") # Cor de fundo
	style_option_button.border_color = Color("7a4841") # Cor da borda
	style_option_button.border_width_left = 2
	style_option_button.border_width_right = 2
	style_option_button.border_width_top = 2
	style_option_button.border_width_bottom = 2
	style_option_button.corner_radius_top_left = 8
	style_option_button.corner_radius_top_right = 8
	style_option_button.corner_radius_bottom_left = 8
	style_option_button.corner_radius_bottom_right = 8
	
	# Aplicando estilos ao OptionButton
	option_button.add_theme_stylebox_override("normal", style_option_button)
	option_button.add_theme_stylebox_override("hover", style_option_button)
	option_button.add_theme_stylebox_override("pressed", style_option_button)

	# Criando estilo para os botões normais
	var style_botao := StyleBoxFlat.new()
	style_botao.bg_color = Color("7a4841") # Cor de fundo do botão
	style_botao.border_color = Color("e7d5b3") # Cor da borda
	style_botao.border_width_left = 2
	style_botao.border_width_right = 2
	style_botao.border_width_top = 2
	style_botao.border_width_bottom = 2
	style_botao.corner_radius_top_left = 12
	style_botao.corner_radius_top_right = 12
	style_botao.corner_radius_bottom_left = 12
	style_botao.corner_radius_bottom_right = 12
	
	# Aplicando estilos aos botões de ação
	for botao in [botao_enviar, botao_proxima, botao_fechar]:
		botao.add_theme_stylebox_override("normal", style_botao)
		botao.add_theme_stylebox_override("hover", style_botao)
		botao.add_theme_stylebox_override("pressed", style_botao)

		# Definindo cor do texto do botão
		botao.add_theme_color_override("font_color", Color("e7d5b3"))
		botao.add_theme_color_override("font_color_hover", Color("d7b594"))

# Função chamada quando o botão de enviar é pressionado
func _on_bt_check_pressed():
	verificar_resposta()

# Função chamada quando o botão de próxima questão é pressionado
func _on_bt_next_pressed():
	proxima_questao()

# Função chamada quando o botão de fechar é pressionado
func _on_bt_close_pressed():
	print("res://scenes/" + Global.actual_scene + ".tscn")
	get_tree().change_scene_to_file("res://scenes/" + Global.actual_scene.to_lower() + ".tscn")  # Volta para a cena normal
