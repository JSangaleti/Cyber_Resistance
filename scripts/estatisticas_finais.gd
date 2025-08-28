extends Control

@onready var lb_tempo          = $VBoxContainer/LbTempo
@onready var lb_acertos_quiz   = $VBoxContainer/LbAcertosQuiz
@onready var lb_pontuacao      = $VBoxContainer/LbPontuacaoFinal

func _ready() -> void:
	# Garante que os singletons existem (ajuda a evitar erros se não estiverem no Autoload)
	var tempo_total := Global.get_tempo_total()
	
	var acertos_quiz := GlobalProgressPuzzles.acertos_quiz

	# Atualiza os Labels (confira se os nós existem na cena)
	if lb_tempo:
		# em segundos com 2 casas — ou troque por format_time() abaixo se preferir mm:ss
		lb_tempo.text = "⏱ Tempo total: %.2f segundos" % tempo_total

	if lb_acertos_quiz:
		# Se quiser mostrar porcentagem literalmente, use '%%' para o símbolo de %
		# Ex.: "📜 %d%% de acertos no Quiz" % 80
		lb_acertos_quiz.text = "📜 %d acertos no Quiz" % acertos_quiz

	if lb_pontuacao:
		var pontuacao := int(1000 - (1.25 * tempo_total) + (acertos_quiz * 100))
		lb_pontuacao.text = "⭐ Pontuação Final: %d pontos" % pontuacao
