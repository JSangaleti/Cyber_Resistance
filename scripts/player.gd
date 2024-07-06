extends CharacterBody2D

signal local_acessado

var velocidade_jogador : float = 150.0
var direcao_movimento : Vector2 = Vector2(0,0)
@onready var animacao := $AnimatedSprite2D as AnimatedSprite2D


func _ready():
	pass


func _process(delta):
	movimentar_jogador()
	acessou_local("Computador")


func movimentar_jogador() -> void:
	# Movimento Horizontal
	if Input.is_action_pressed("mov_direita"):
		direcao_movimento.x = 1
		animacao.play("direita")
	elif Input.is_action_pressed("mov_esquerda"):
		direcao_movimento.x = - 1
		animacao.play("esquerda")
	else:
		direcao_movimento.x = 0

	
		
	# Movimento Vertical
	if Input.is_action_pressed("mov_cima"):
		direcao_movimento.y = -1
		animacao.play("cima")

	elif Input.is_action_pressed("mov_baixo"):
		direcao_movimento.y = 1
		animacao.play("baixo")
	
	else:
		direcao_movimento.y = 0 	
		
	if not Input.is_action_pressed("mov_cima") and not Input.is_action_pressed("mov_baixo") and not Input.is_action_pressed("mov_esquerda") and not Input.is_action_pressed("mov_direita"):
		animacao.stop()
		animacao.frame = 1
		

	#Para que o jogador tenha velocidade: 
	velocity = direcao_movimento.normalized() * velocidade_jogador
	# O .normalized é para que funcione corretamente nas diagonais, sem acelerar. 
	move_and_slide()
	
func acessou_local(local):
	if Global.cena_anterior == local:
		emit_signal("local_acessado")


