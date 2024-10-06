extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_finished():
	$BgGame.play()
