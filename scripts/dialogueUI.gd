extends Control

@onready var rt_name = $NinePatchRect/Name
@onready var rt_text = $NinePatchRect/Text
@onready var bt_next = $BtNext

var current_dialogue: Array = []
var current_index: int = 0

func show_dialog(dialogue: Array):
	current_dialogue = dialogue
	current_index = 0
	update_text()
	show()
	
func update_text():
	if current_index < current_dialogue.size():
		rt_name.text = current_dialogue[current_index]['name']
		rt_text.text = current_dialogue[current_index]['text']
		
#	$NinePatchRect/Name.text = dialogo_missao[id_dialogo_missao]['name']
	#$NinePatchRect/Text.text = dialogo_missao[id_dialogo_missao]['text']
	else:
		close_dialog()

func _on_bt_next_pressed():
	current_index += 1
	update_text()

func close_dialog():
	hide()
	emit_signal("dialog_finished")
