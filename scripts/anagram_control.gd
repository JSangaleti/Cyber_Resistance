extends Control

@onready var lb_word = $LbWord
@onready var input_answer = $LineEdit
@onready var bt_check = $BtCheck
@onready var lb_result = $LbResult
@onready var bt_restart = $BtRestart

# Variáveis globais
var original_word: String = "" # Palavra original
var shuffled_word: String = "" # Palavra embaralhada
var attempts: int = 0 # Tentativas
var max_attempts: int = 3 # Máximo de tentativas

# Lista de palavras para o jogo
var word_list: Array = ["banana", "gato", "carro", "computador", "teclado"]

func _ready() -> void:
	start_game()

func start_game() -> void:
	# Reinicia o jogo
	attempts = 0
	lb_result.text = ""
	input_answer.text = ""
	bt_check.disabled = false
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
		lb_result.text = "Parabéns! Você acertou."
		bt_check.disabled = true
	else:
		attempts += 1
		if attempts >= max_attempts:
			lb_result.text = "Você perdeu! A palavra era: %s" % original_word
			bt_check.disabled = true
		else:
			lb_result.text = "Tente novamente. Restam %d tentativas." % (max_attempts - attempts)


func _on_btCheck_pressed() -> void:
	check_answer()
	
func _on_btRestart_pressed() -> void:
	start_game()
