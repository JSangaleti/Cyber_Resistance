extends Node2D

@export var nextScene : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
#Os comandos seguintes são para o ajuste de posição do personagem ao passar por uma transição de cenas.
	get_tree().change_scene_to_file(nextScene)
	#	Armazeno o nome da cena em uma variável global para depois, realizar verificações. 
	Global.cena = "Computador"

	print("Cena, variável global -> " + Global.cena)
	
#-----

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
