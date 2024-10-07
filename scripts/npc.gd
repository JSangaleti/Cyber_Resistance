extends CharacterBody2D


const velocidade : float = 35.0
var status = INATIVO

var direcao: Vector2 = Vector2.RIGHT
var posicao_inicial

#para verificar se o NPC vai poder estar se movimentando ou não.
var em_movimento = true
var em_conversa = false

var player
var player_em_area_de_conversa = false

# Com enum, temos de forma simplificada isso: [INATIVO, NOVA_DIRECAO, MOVIMENTO]
# Lembrando então, que os index são: 0, 1, 2
enum{
	INATIVO,
	NOVA_DIRECAO,
	MOVIMENTO
}

func _ready():
	randomize()
	posicao_inicial = position
	

#Esta função:
# - analisa o status do personagem (se está Inativo (0), em Nova Direção (1), em Movimento (2);
# - ativa as animações de movimento do player de acordo com a direção do mesmo;
# - a direção é escolhida de forma aleatória, por meio de um vetor e da função escolher();
# - também dá inicio ao Diálogo e a Missão;

var anim_by_dir = {
	Vector2.LEFT: 	"esquerda", 
	Vector2.RIGHT: 	"direita",
	Vector2.UP: 	"cima",
	Vector2.DOWN: 	"baixo"
}

func _process(delta):
	direcao = Vector2.RIGHT
	movimento(delta)
	
	#if status == INATIVO or status == NOVA_DIRECAO:
		#$AnimatedNPC.frame = 1
		#
	#elif status == MOVIMENTO and !em_conversa:
	$AnimatedNPC.play(anim_by_dir[direcao])
	
	#if em_movimento:
		#match status:
			#INATIVO:
				#pass
			#NOVA_DIRECAO:
				##direcao = escolher([Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP])
				#direcao = Vector2.RIGHT
			#MOVIMENTO:
				#movimento(delta)

#	Quando o player pressiona a tecla C, vínculada a "chat" e está na área definida para conversa...
	#if Input.is_action_just_pressed("chat") and player_em_area_de_conversa and Global.missao_ativa == false:
		##Posso criar uma animação INATIVO para o personagem. Mas como ainda não tenho, apenas deixo no frame 1
		#$AnimatedNPC.frame = 1
##		Tocando efeito sonoro
		#ControleMusica.clique_simples()
		##Chamando uma função que está no script Dialogo. É para iniciar o diálogo
		#$Dialogo.start()
		#em_movimento = false
		#em_conversa = true

#	Quando o player pressiona a tecla Q, que está vinculada a "quest" e o player está na área de conversa...
	if Input.is_action_just_pressed("quest") and player_em_area_de_conversa:
		print("A quest foi iniciada")
		$NPC_Quest.proxima_missao()
		#Tocando efeito sonoro
		ControleMusica.clique_simples()
		$AnimatedNPC.frame = 1
		em_movimento = false
		em_conversa = true


# Esta função recebe um array, embaralha os elementos e retorna o primeiro elemento. 
func escolher(array):
	array.shuffle()
	return array.front()

# Quando o NPC não está em uma conversa, essa função permite que ele se movimente. 
func movimento(delta):
	if !em_conversa:
		velocity = direcao * 2000 * delta
		move_and_slide()

#Player entrou na área de conversa? ....
func _on_chat_detector_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_em_area_de_conversa = true

#Player saiu da área de conversa? ....
func _on_chat_detector_body_exited(body):
	if body.is_in_group("Player"):
		player_em_area_de_conversa = false

# Quando o NPC não está em uma conversa, por meio da função escolher(vetor), é selecionado um tempo e uma ação para o NPC.  
func _on_timer_timeout():
	if !em_conversa:
		$Timer.wait_time = escolher([0.5, 1.0, 1.5, 2.0])
		status = escolher([INATIVO, NOVA_DIRECAO, MOVIMENTO])

# Este é um sinal que eu criei. Ele foi criado no Script DialogoPlayer para indicar que o diálogo acabou
# Quando executado, o player volta a estar em movimento
func _on_dialogo_dialogo_acabou():
	em_conversa = false
	em_movimento = true

# Este sinal vem do nó NPC_Quest. Ele foi criado para indicar quando o menu quest for fechado.
# Quando executado, o player volta a estar em movimento
func _on_npc_quest_quest_menu_fechado():
	em_conversa = false
	em_movimento = true


func _on_dialogo_de_missao_dialogo_missao_acabou():
	em_conversa = false
	em_movimento = true
