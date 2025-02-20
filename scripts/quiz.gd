extends Control

# Estrutura das questões e respostas
var questoes = [
	{
		"pergunta": "O que significa 'DDoS'?",
		"tipo_resposta": "marcada",
		"respostas": ["Distributed Denial of Service", "Data Destruction System", "Definite Denial of Security"],
		"resposta_correta": 0
	},
	{
		"pergunta": "Qual o principal objetivo de um ataque de 'Phishing'?",
		"tipo_resposta": "marcada",
		"respostas": ["AAAAA", "SDASDASDASDAS", "ASDASDASDAS"],
		"resposta_correta": 2
	}
]

var indice_questao_atual = 0

@onready var label_questao =$VBoxContainer/LbQuestion
@onready var option_button = $VBoxContainer/OptionButton
@onready var line_edit_resposta = $VBoxContainer/LineEdit
@onready var botao_verificar = $VBoxContainer/BtCheck
@onready var label_feedback = $VBoxContainer/LbFeedback

func _ready():
	mostrar_questao()

func mostrar_questao():
	label_questao.text = questoes[indice_questao_atual]["pergunta"]
	if questoes[indice_questao_atual]["tipo_resposta"] == "marcada":
		option_button.visible = true
		line_edit_resposta.visible = false
		option_button.clear()
		for resposta in questoes[indice_questao_atual]["respostas"]:
			option_button.add_item(resposta, option_button.get_item_count())
	elif questoes[indice_questao_atual]["tipo_resposta"] == "escrita":
		option_button.visible = false
		line_edit_resposta.visible = true
		line_edit_resposta.text = ""

func verificar_resposta():
	if questoes[indice_questao_atual]["tipo_resposta"] == "marcada":
		if option_button.selected == questoes[indice_questao_atual]["resposta_correta"]:
			label_feedback.text = "Resposta correta!"
		else:
			label_feedback.text = "Resposta incorreta. Tente novamente."
	elif questoes[indice_questao_atual]["tipo_resposta"] == "escrita":
		var resposta_digitada = line_edit_resposta.text.strip_n_tags()
		if resposta_digitada.to_lower() == questoes[indice_questao_atual]["resposta_correta"].to_lower():
			label_feedback.text = "Resposta correta!"
		else:
			label_feedback.text = "Resposta incorreta. Tente novamente."

func _on_btCheck_pressed() -> void:
	verificar_resposta()
	# Avançar para a próxima questão após verificar a resposta
	indice_questao_atual += 1
	if indice_questao_atual < questoes.size():
		mostrar_questao()
	else:
		label_questao.text = "Fim do Quiz. Parabéns!"
		option_button.visible = false
		line_edit_resposta.visible = false
		botao_verificar.disabled = true
