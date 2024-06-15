extends Node2D

@export var nextScene : String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
#Os comandos seguintes são para o ajuste de posição do personagem ao passar por uma transição de cenas.
	get_tree().change_scene_to_file(nextScene)
	
#-----

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
