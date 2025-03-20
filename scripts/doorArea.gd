extends Area2D

@export var nextScene : String = ""

var player_on_door : bool = false

signal updatePlayerState
signal updatePosition

signal changed_scene(scene)

func _process(delta):
	if player_on_door and Input.is_action_just_pressed("action"):
		Global.last_scene = get_parent().name
		_change_scene(nextScene)

func _change_scene(scene):
	emit_signal("changed_scene", scene)
	get_tree().change_scene_to_file(scene)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_on_door = true
		
func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_on_door = false
	
