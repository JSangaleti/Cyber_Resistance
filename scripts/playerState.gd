extends Node2D

class PlayerPosition:
	var scene : StringName
	var positionState : Vector2

class PlayerPositionCache:
	var positions : Array[PlayerPosition] = []

func save_state():
	var cachePositions : PlayerPositionCache
	var p : PlayerPosition

	p = PlayerPosition.new()
	cachePositions = PlayerPositionCache.new()

	#p.scene = "myScene"
	#p.position = Vector2(1,2)

	cachePositions.positions.append(p)

	print(cachePositions.positions[0].scene)
	print(cachePositions.positions[0].positionState)
	print("P --------> ", p)

func load_state():
	var cachePositions : PlayerPositionCache
	var p : PlayerPosition

	p = PlayerPosition.new()
	cachePositions = PlayerPositionCache.new()

	cachePositions.positions.append(p)
# Called when the node enters the scene tree for the first time.
func _ready():
	save_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
