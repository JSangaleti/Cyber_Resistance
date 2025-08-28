extends Node2D

var score := 0
@onready var PasswordItem = preload("res://scenes/passwordItem.tscn")

var possible_passwords = [
	"123456","qwerty","senha123","maria","15/01/2016","mingau1234","donaBernadete3",
	"Sergipe","flamengo2024","abc123","password","gato12345","meuAniversario",
	"Z3!kL0@9","Aq4_7!Lm","r0b0t#2024","K9@uP!x3","tR4-$mn2","WQ!KL#90","NCX7-GHFS!",
	"234-0A59","SiJ5#4g","Tg!9a$Lz","m@klJKW32","kjlAs23!"
]

var correct_passwords = [
	"Tg!9a$Lz","SiJ5#4g","m@klJKW32","kjlAs23!","234-0A59","WQ!KL#90","NCX7-GHFS!","tR4-$mn2",
	"Z3!kL0@9","Aq4_7!Lm","K9@uP!x3"
]

func _ready():
	randomize()
	$Timer.wait_time = 1.2
	$Timer.timeout.connect(_on_Timer_timeout) # garante conexão
	$Timer.start()

func _on_Timer_timeout() -> void:
	spawn_password()

func spawn_password():
	var pwd = possible_passwords.pick_random()
	var item = PasswordItem.instantiate()
	item.password_text = pwd
	item.is_correct = pwd in correct_passwords

	var screen_size = get_viewport_rect().size
	item.position = Vector2(randi() % int(screen_size.x - 100) + 50, -20)

	add_child(item)
	item.input_event.connect(_on_item_clicked.bind(item))


func update_score(score):
	$LbPlacar.text = str(score);
	
func _on_item_clicked(_viewport, event, _shape_idx, item):
	if event is InputEventMouseButton and event.pressed:
		if item.is_correct:
			score += 1
			if score >= 10: # “no mínimo 10”
				GlobalProgressPuzzles.add_password_piece("caça-senhas")
				get_tree().change_scene_to_file("res://scenes/computer.tscn")
		else:
			score = max(score - 1, 0) # perde 1, sem ficar negativo
		update_score(score);
		item.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		queue_free()
		get_tree().change_scene_to_file("res://scenes/computer.tscn")
		
