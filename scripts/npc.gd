extends CharacterBody2D

# Movimento do NPC ---
const _NPC_VELOCITY: float = 35.0
var _status: int = IDLE
var _movement_direction: Vector2 = Vector2.ZERO
var _in_movement: bool = true
# ---

# Relacionado ao Diálogo ---
var _in_chat: bool = false
var _player: Node
var in_dialogue = false

@onready var area2d = $ChatDetector
@onready var sprite = $Animated
@onready var dialog_manager = $"../DialogManager"

signal start_dialogue(dialogue)
signal body_entered(body)
signal talking_to_npc

# Enum para estados do NPC
enum {
	IDLE,
	NEW_DIRECTION,
	MOVEMENT
}

func _ready() -> void:
	randomize()
	$Timer.wait_time = select([0.5, 1.0, 1.5, 2.0])
	area2d.body_entered.connect(self._on_chat_detector_body_entered)
	area2d.body_exited.connect(self._on_chat_detector_body_exited)

	# Conecte o sinal ao DialogUI
	var dialog_ui = $DialogUI
	self.start_dialogue.connect(dialog_ui.show_dialog)
	var tasks_node = $Tasks
	self.talking_to_npc.connect(tasks_node._task_01)
	
func npc_movement(delta: float) -> void:
	if _movement_direction != Vector2.ZERO:
		velocity = _movement_direction.normalized() * _NPC_VELOCITY
		move_and_slide()

func dialog_start():
	var file = FileAccess.open("res://assets/dialogs/npcs/professor/dialogues.json", FileAccess.READ)
	var dialogue = JSON.parse_string(file.get_as_text())
	emit_signal("start_dialogue", dialogue)
	emit_signal("talking_to_npc") # Sinal para missão 01
	print("Sinais emitidos")

func finish_dialog():
	in_dialogue = false
	_status = NEW_DIRECTION
	_in_movement = true
	
func _on_chat_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = true
		body.current_npc = self
		print("Chat detector - Player está na área de chat")

func _on_chat_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.can_interact = false
		body.current_npc = null

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

func select(array: Array) -> Variant:
	array.shuffle()
	return array.front()
