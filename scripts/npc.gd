extends CharacterBody2D

const velocidade : float = 80.0
var status = INATIVO

var direcao = Vector2.RIGHT
var posicao_inicial

#para verificar se o NPC vai poder estar se movimentando ou não.
var em_movimento = true
var em_conversa = false

var player
var player_em_area_de_conversa = false

enum{
	INATIVO,
	NOVA_DIRECAO,
	MOVIMENTO
}

func _ready():
	randomize()
	posicao_inicial = position
	
func _process(delta):
	if status == 0 or status == 1:
		$AnimatedNPC.frame = 1
		
	elif status == 2 and !em_conversa:
		if direcao.x == -1:
			$AnimatedNPC.play("esquerda")
		if direcao.x == 1:
			$AnimatedNPC.play("direita")
		if direcao.y == -1:
			$AnimatedNPC.play("cima")
		if direcao.y == 1:
			$AnimatedNPC.play("baixo")
			
	if em_movimento:
		match status:
			INATIVO:
				pass
			NOVA_DIRECAO:
				direcao = escolher([Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP])
			MOVIMENTO:
				movimento(delta)
	if Input.is_action_just_pressed("chat"):
		#Chamando uma função que está no script Dialogo. É para iniciar o diálogo
		$Dialogo.start()
		print("Conversando com o NPC")
		em_movimento = false
		em_conversa = true
		#Posso criar uma animação INATIVO para o personagem. Mas como ainda não tenho, apenas deixo no frame 1
		$AnimatedNPC.frame = 1

#Esta função recebe um array, embaralha os elementos e retorna o primeiro elemento. 
func escolher(array):
	array.shuffle()
	return array.front()

func movimento(delta):
	if !em_conversa:
		position += direcao * velocidade * delta
		
		

#Player entrou na área de conversa? ....
func _on_chat_detector_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_em_area_de_conversa = true
		print("Está na area. ")

#Player saiu da área de conversa? ....
func _on_chat_detector_body_exited(body):
	if body.is_in_group("Player"):
		player_em_area_de_conversa = false
		print("Não está mais na área.")


func _on_timer_timeout():
	$Timer.wait_time = escolher([0.5, 1.0, 1.5, 2.0])
	status = escolher([INATIVO, NOVA_DIRECAO, MOVIMENTO])

#Este é um sinal que EU criei. Ele foi criado no Script DialogoPlayer
func _on_dialogo_dialogo_acabou():
	em_conversa = false
	em_movimento = true
