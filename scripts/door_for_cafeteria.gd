extends Area2D

@export var nextScene : String = ""
var actualScene : String = "Cafeteria"

var player_on_door : bool = false

signal updatePosition(scene, lastScene)


func _ready() -> void:
	pass

func _process(delta):
	if player_on_door and Input.is_action_just_pressed("action"):
		_change_scene(nextScene)
		

func _change_scene(nextScene):
	get_tree().change_scene_to_file(nextScene)
	emit_signal("updatePosition", nextScene, actualScene)
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_on_door = true
		

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_on_door = false
