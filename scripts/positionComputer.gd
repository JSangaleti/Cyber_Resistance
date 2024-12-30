extends Node2D

@export var nextScene : String = ""
@onready var btTerminal = $BtTerminal

var mouse_entered := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().change_scene_to_file(nextScene)
	Global.update_scene("Computer")
	
#-----


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_bt_terminal_pressed():
	get_tree().change_scene_to_file("res://scenes/controls/terminal.tscn")
	print("ok, deu certo")
