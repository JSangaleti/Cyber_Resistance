extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
#Os comandos seguintes são para o ajuste de posição do personagem ao passar por uma transição de cenas.
	if Global.from_scene != null:
		$Player.set_position(get_node(Global.from_scene + "pos").position)
#------------------------------------------------------------------------------------------------------


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
