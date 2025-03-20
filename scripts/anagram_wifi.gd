extends Control

@onready var lb_word = $BoxContainer/VBoxContainer/LbWord
@onready var input_answer = $BoxContainer/VBoxContainer/LineEdit
@onready var bt_check = $BoxContainer/VBoxContainer/HBoxContainer/BtCheck
@onready var lb_result = $BoxContainer/VBoxContainer/LbResult
@onready var bt_restart = $BoxContainer/VBoxContainer/HBoxContainer/BtRestart

# Variáveis globais
var original_word: String = "" # Palavra original
var shuffled_word: String = "" # Palavra embaralhada
var attempts: int = 0 # Tentativas
var max_attempts: int = 3 # Máximo de tentativas

var remaining_time = 10 # segundos 

# Lista de palavras para o jogo
var word_list: Array = ["Bolo_De_Fuba", "Cafe_com_Leite", "Pao_de_Queijo", "Dona_Bernadete"]

# Sinal para a realização de tasks
signal wifi_conected

func _ready() -> void:
	start_game()

func start_game() -> void:
	# Reinicia o jogo
	attempts = 0
	lb_result.text = "                                           "
	input_answer.text = ""
	input_answer.editable = true
	bt_check.disabled = false
	bt_check.visible = true
	bt_restart.disabled = true
	bt_restart.visible = false
	original_word = word_list[randi() % word_list.size()]
	shuffled_word = shuffle_word(original_word) #embaralhando a palavra
	lb_word.text = shuffled_word

func shuffle_word(word: String) -> String:
	var letters: Array = word.split("") # Letras recebe a palavra.
	letters.shuffle() # Embaralhando o array letras...
	return "".join(letters) # Retornando a palavra embaralhada; com o join, as letras são printadas separadas por ""

func check_answer() -> void:
	var answer: String = input_answer.text
	if answer == original_word:
		lb_result.add_theme_color_override("font_color", Color(0.8706, 0.6196, 0.2549))  # Mudando para cor verde
		
		lb_result.text = "                 ...                     "
		lb_result.add_theme_color_override("font_color", Color(0.6588, 0.7922, 0.3451))  # Mudando para cor verde
		await get_tree().create_timer(randf_range(2, 6)).timeout  # Espera um tempo aleatório entre 2 e 6 segundos
		lb_result.text = "                    Conectando...                       "
		
		await get_tree().create_timer(3).timeout  # Espera 3 segundos
		lb_result.text = ""  # Limpa o lb_result

		lb_result.text = "          Conectado com Sucesso!          "
		emit_signal("wifi_conected")
		
# Aguarda dois segundos para limpar tudo e aparecer a opção de desconectar
		await get_tree().create_timer(3).timeout
		clean()
		bt_restart.visible = true
		bt_restart.disabled = false
		bt_check.disabled = true
	else:
		attempts += 1
		if attempts >= max_attempts:
			$Timer.start()  # Inicia o Timer
			bt_check.disabled = true
		else:
			lb_result.text = "                 ...                     "
			lb_result.add_theme_color_override("font_color", Color(0.6588, 0.7922, 0.3451))  # Mudando para cor verde
			await get_tree().create_timer(2).timeout
			lb_result.text = "Tente novamente. Restam %d tentativas." % (max_attempts - attempts)

func clean() -> void:
	attempts = 0
	lb_result.text = "            Conectado.               "
	input_answer.text = "*******"
	input_answer.editable = false
	bt_check.disabled = true
	bt_check.visible = false
	original_word = ""
	shuffled_word = "" #embaralhando a palavra
	lb_word.text = ""

func _on_btCheck_pressed() -> void:
	check_answer()
	
func _on_btRestart_pressed() -> void:
	start_game()
	lb_result.add_theme_color_override("font_color", Color(0.811, 0.341, 0.235))
	lb_result.text = "            Desconectado.               "

func _on_timer_timeout() -> void:
	remaining_time -= 1
	lb_result.add_theme_color_override("font_color", Color(0.811, 0.341, 0.235)) #mudando para cor vermelha
	if remaining_time > 0:
		lb_result.text = "Tente novamente em %d segundos." % (remaining_time)
		$Timer.start()  # Para o Timer
	else:
		lb_result.text = "Tente novamente em %d segundos." % (remaining_time)
		$Timer.stop()  # Reinicia o Timer
		lb_result.text = ""
		remaining_time = 10
		
		start_game() # Restart, nova tentativa. 
