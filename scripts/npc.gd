extends CharacterBody2D

const _NPC_VELOCITY: float = 35.0
var _status: int = IDLE

var _movement_direction: Vector2 = Vector2.ZERO
#var _inicial_position: Vector2

# Variáveis para verificar se o NPC está em movimento.
var _in_movement: bool = true
var _in_chat: bool = false

var _player: Node
#var _player_in_chat_area: bool = false

# Com ENUM, temos de forma simplificada: [IDLE, NOVA_DIRECAO, MOVIMENTO]
# Lembrando então, que os index são: 0, 1, 2
enum {
	IDLE,
	NEW_DIRECTION,
	MOVEMENT
}

func _ready() -> void:
	randomize()
	#_inicial_position = position
	$Timer.wait_time = select([0.5, 1.0, 1.5, 2.0])

# Esta função:
# - analisa o status do personagem (se está IDLE (0), em Nova Direção (1), em Movimento (2));
# - ativa as animações de movimento do player de acordo com a direção do mesmo;
# - a direção é escolhida de forma aleatória, por meio de um vetor e da função select();
# - também dá inicio ao Diálogo e a Missão;

# Dicionário. Chave: Valor. 
var _animate_by_direction: Dictionary = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.ZERO: "stop"
}

func _process(delta: float) -> void:
	if _in_movement:
		npc_movement(delta)
		$Animated.play(_animate_by_direction[_movement_direction])
	else:
		$Animated.stop()
		$Animated.frame = 1


# Esta função recebe um Array, embaralha os elementos e retorna o primeiro elemento.
# O tipo Variant é próprio da GDScript, e é usado quando não se sabe exatamente qual tipo será retornado. 
func select(array: Array) -> Variant:
	array.shuffle()
	return array.front()

# Quando o NPC não está em uma conversa, essa função permite que ele se movimente.
func npc_movement(delta: float) -> void:
	if _movement_direction != Vector2.ZERO:
		velocity = _movement_direction.normalized() * _NPC_VELOCITY
		move_and_slide()
## Player entrou na área de conversa? ....
#func _on_chat_detector_body_entered(body: Node) -> void:
	#if body.is_in_group("Player"):
		#_player = body
		#_player_in_chat_area = true
		#_in_chat = true
		#_in_movement = false
#
## Player saiu da área de conversa? ....
#func _on_chat_detector_body_exited(body: Node) -> void:
	#if body.is_in_group("Player"):
		#_player_in_chat_area = false
		#_in_chat = false
		#_in_movement = true
#
# Quando o NPC não está em uma conversa, por meio da função select(vetor), é selecionado um tempo e uma ação para o NPC.
func _on_timer_timeout() -> void:
	if !_in_chat:
		$Timer.wait_time = select([0.5, 1.0, 1.5, 2.0])
		_status = select([IDLE, NEW_DIRECTION, MOVEMENT])

		match _status:
			IDLE:
				_in_movement = false
			NEW_DIRECTION:
				_movement_direction = select([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])
			MOVEMENT:
				_in_movement = true

# Este é um sinal que eu criei. Ele foi criado no Script DialogoPlayer para indicar que o diálogo acabou
# Quando executado, o player volta a estar em movimento
#func _on_dialogo_dialogo_acabou() -> void:
	#_in_chat = false
	#_in_movement = true
#
## Este sinal vem do nó NPC_Quest. Ele foi criado para indicar quando o menu quest for fechado.
## Quando executado, o player volta a estar em movimento
#func _on_npc_quest_quest_menu_fechado() -> void:
	#_in_chat = false
	#_in_movement = true
#
#func _on_dialogo_de_missao_dialogo_missao_acabou() -> void:
	#_in_chat = false
	#_in_movement = true
