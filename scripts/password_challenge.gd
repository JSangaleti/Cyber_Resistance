extends CanvasLayer

# Estrutura de desafios
var challenges = [
	{
		"hints": [
			"A senha tem 3 dígitos.",
			"O segundo dígito é maior que o primeiro.",
			"A soma dos dígitos é 10."
		],
		"answer": "472",
		"piece": "CYP"
	},
	{
		"hints": [
			"A senha é uma palavra.",
			"Está relacionada a algo que você deve proteger.",
			"Começa com 'S' e termina com 'A'."
		],
		"answer": "SENHA",
		"piece": "3R_"
	},
	{
		"hints": [
			"A senha é composta por 2 dígitos.",
			"O primeiro é o dobro do segundo.",
			"A soma é 12."
		],
		"answer": "84",
		"piece": "S3C"
	}
]

var current_challenge = {}
@onready var hints_container = $Panel/VBoxContainer
@onready var input_field = $Panel/LineEdit
@onready var feedback_label = $Panel/LbFeedback

func _ready():
	generate_challenge()

func generate_challenge():
	# Escolhe desafio aleatório
	current_challenge = challenges.pick_random()
	
	# Limpa dicas antigas
	for child in hints_container.get_children():
		child.queue_free()
	
	# Exibe dicas
	for h in current_challenge["hints"]:
		var hint_label = Label.new()
		hint_label.text = "• " + h
		hints_container.add_child(hint_label)
	
	# Limpa campo de texto e feedback
	input_field.text = ""
	feedback_label.text = ""

func _on_Button_pressed():
	var attempt = input_field.text.strip_edges()
	if attempt == current_challenge["answer"]:
		feedback_label.text = "✅ Correto!"
		await get_tree().create_timer(2.0).timeout
		GlobalProgressPuzzles.add_password_piece("enigma")
		get_tree().change_scene_to_file("res://scenes/computer.tscn")
		
	else:
		feedback_label.text = "❌ Tente novamente."
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		queue_free()
		get_tree().change_scene_to_file("res://scenes/computer.tscn")
