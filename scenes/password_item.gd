extends Area2D

@export var password_text: String = ""
@export var is_correct: bool = false

var fall_speed := 250.0

func _ready():
	$Label.text = password_text

func _process(delta):
	position.y += fall_speed * delta
	
	# Se sair da tela, some
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()
