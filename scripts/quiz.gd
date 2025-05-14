extends Control

# Estrutura das questões e respostas
var questions: Array = []  # Lista de questões embaralhadas
var indice_atual: int = 0  # Índice da questão atual na lista
var acertos: int = 0
var erros: int = 0

# Armazenar respostas do jogador
var respostas_dadas: Array = []

# Referências aos nós
@onready var panel: CanvasLayer = $Panel
@onready var label_questao: Label = $Panel/VBoxContainer/LbQuestion
@onready var option_button: OptionButton = $Panel/VBoxContainer/OpAlternatives
@onready var botao_enviar: Button = $Panel/VBoxContainer/BtCheck
@onready var label_feedback: Label = $Panel/VBoxContainer/LbFeedback
@onready var label_explicacao: Label = $Panel/VBoxContainer/LbExplanation
@onready var botao_proxima: Button = $Panel/VBoxContainer/BtNext
@onready var label_resultado_final: Label = $Panel/VBoxContainer/LbResult
@onready var botao_fechar: Button = $Panel/VBoxContainer/BtClose

signal finished_quiz(successes, mistakes)

func _ready() -> void:
	$Panel.hide()
	print("Quiz carregado!")
	
	print("QUESTÕES NO QUIZ::::::::::::::::::::::")
	for q in Global.questions:
		print(q.get("assunto", "SEM ASSUNTO"), "::", q.get("texto", ""))

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

func _on_quiz_open() -> void:
	if Global.questions.size() > 0:
		questions = Global.questions.duplicate(true)
		embaralhar_questoes()
		aplicar_estilos()
		ajustar_interface()
		indice_atual = 0
		mostrar_questao()
		botao_proxima.visible = false
		label_resultado_final.visible = false
		botao_fechar.visible = false
	else:
		label_questao.text = "Nenhuma questão carregada."
	$Panel.show()

func ajustar_interface() -> void:
	$Panel/VBoxContainer.custom_minimum_size.x = 600
	for label in [label_questao, label_feedback, label_explicacao, label_resultado_final]:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func mostrar_questao() -> void:
	if indice_atual >= questions.size():
		return

	var questao: Dictionary = questions[indice_atual]
	label_questao.text = questao.get("texto", "")
	label_feedback.text = ""
	label_explicacao.add_theme_color_override("font_color", Color("341c27"))
	label_explicacao.text = ""
	option_button.clear()

	for alternativa in questao.get("alternativas", []):
		option_button.add_item(alternativa.get("texto", ""))

	botao_enviar.disabled = false
	botao_proxima.visible = false
	option_button.visible = true

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

	var questao: Dictionary = questions[indice_atual]
	var letra_selecionada: String = questao.get("alternativas", [])[indice_selecionado].get("letra", "")

	# Salvar os dados da resposta do jogador -----------------------------
	respostas_dadas.append({
		"pergunta": questao.get("texto", ""),
		"alternativas": questao.get("alternativas", []),
		"resposta_correta": questao.get("resposta_correta", ""),
		"letra_selecionada": letra_selecionada,
		"texto_selecionado": questao.get("alternativas", [])[indice_selecionado].get("texto", ""),
		"explicacao": questao.get("explicacao", ""),
		"acertou": letra_selecionada == questao.get("resposta_correta", "")
	})
# --------------------------------------------------------------------------

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
	indice_atual += 1

	if indice_atual < questions.size():
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
	# Mesma estilização que você criou — mantida sem alterações
	var popup = option_button.get_popup()
	var style_item := StyleBoxFlat.new()
	style_item.bg_color = Color("4d2b32")
	style_item.border_color = Color("7a4841")
	style_item.border_width_left = 2
	style_item.border_width_right = 2
	style_item.border_width_top = 2
	style_item.border_width_bottom = 2
	popup.add_theme_stylebox_override("panel", style_item)
	popup.add_theme_color_override("font_color", Color("e7d5b3"))
	popup.add_theme_color_override("font_color_hover", Color("d7b594"))

	var style_option_button := StyleBoxFlat.new()
	style_option_button.bg_color = Color("4d2b32")
	style_option_button.border_color = Color("7a4841")
	style_option_button.border_width_left = 2
	style_option_button.border_width_right = 2
	style_option_button.border_width_top = 2
	style_option_button.border_width_bottom = 2
	style_option_button.corner_radius_top_left = 8
	style_option_button.corner_radius_top_right = 8
	style_option_button.corner_radius_bottom_left = 8
	style_option_button.corner_radius_bottom_right = 8
	option_button.add_theme_stylebox_override("normal", style_option_button)
	option_button.add_theme_stylebox_override("hover", style_option_button)
	option_button.add_theme_stylebox_override("pressed", style_option_button)

	var style_botao := StyleBoxFlat.new()
	style_botao.bg_color = Color("7a4841")
	style_botao.border_color = Color("e7d5b3")
	style_botao.border_width_left = 2
	style_botao.border_width_right = 2
	style_botao.border_width_top = 2
	style_botao.border_width_bottom = 2
	style_botao.corner_radius_top_left = 12
	style_botao.corner_radius_top_right = 12
	style_botao.corner_radius_bottom_left = 12
	style_botao.corner_radius_bottom_right = 12

	for botao in [botao_enviar, botao_proxima, botao_fechar]:
		botao.add_theme_stylebox_override("normal", style_botao)
		botao.add_theme_stylebox_override("hover", style_botao)
		botao.add_theme_stylebox_override("pressed", style_botao)
		botao.add_theme_color_override("font_color", Color("e7d5b3"))
		botao.add_theme_color_override("font_color_hover", Color("d7b594"))

func _on_bt_check_pressed():
	verificar_resposta()

func _on_bt_next_pressed():
	proxima_questao()

func _on_bt_close_pressed():
	$GerarRelatorioTXT.gerar_relatorio(respostas_dadas, acertos, erros)

	emit_signal("finished_quiz", acertos, erros)
	$Panel.hide()
