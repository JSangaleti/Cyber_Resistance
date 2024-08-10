extends CharacterBody2D

signal local_acessado

var velocidade_jogador : float = 150.0
var direcao_movimento : Vector2 = Vector2(0,0)
@onready var animacao := $AnimatedSprite2D as AnimatedSprite2D


func _ready():
	pass


func _process(_delta):
	movimentar_jogador()
	animate()
	acessou_local("Computador")


func movimentar_jogador() -> void:
	direcao_movimento = Input.get_vector("mov_esquerda", "mov_direita", "mov_cima", "mov_baixo")
		
	#Para que o jogador tenha velocidade: 
	velocity = direcao_movimento.normalized() * velocidade_jogador
	# O .normalized é para que funcione corretamente nas diagonais, sem acelerar. 
	move_and_slide()
	
	
func animate() -> void:
	if direcao_movimento.x > 0:
		animacao.play("direita")
	elif direcao_movimento.x < 0:
		animacao.play("esquerda")
	elif direcao_movimento.y < 0:
		animacao.play("cima")
	elif direcao_movimento.y > 0:
		animacao.play("baixo")
		
	if direcao_movimento == Vector2.ZERO:
		animacao.stop()
		animacao.frame = 1
	
	
func acessou_local(local):
	if Global.cena_anterior == local:
		emit_signal("local_acessado")

