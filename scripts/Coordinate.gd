extends Node2D

func _ready():
	pass

func spawn(pos:Vector2, value:float)->void:
	position = pos
	var col := Color.white
	if (value < 0.25):
		col = Color.blue
	elif (value < .35):
		col = Color.yellow
	elif (value < .8):
		col = Color.green
	$Sprite.modulate = col