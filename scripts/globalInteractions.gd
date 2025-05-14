extends CanvasLayer

# Pré-carrega a cena de Interactions (o painel de missões)
var interactions_scene = preload("res://scenes/interactions.tscn")
var interactions_instance = null

func _ready():
	# Se a interface ainda não foi instanciada, instancie-a e adicione-a como filho
	if interactions_instance == null:
		interactions_instance = interactions_scene.instantiate()
		add_child(interactions_instance)
		interactions_instance.visible = false
	if Global.actual_scene == "MainMenuScreen":
		remove_child(interactions_instance)
		

func update_interactions_painel():
	if Global.actual_scene == "Computer" || Global.actual_scene == "MainMenuScreen":
		remove_child(interactions_instance)
	else:
		add_child(interactions_instance)
	

	
