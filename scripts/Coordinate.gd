extends Node2D

func _ready():
	pass

func spawn(pos:Vector2, value:float)->void:
	position = pos
	var col := Color.white
	if (value < 0.25):
		col = Color(0, 0, value + .75)
	elif (value < .35):
		col = Color(value + .65, value + .65, 0)
	elif (value < .9):
		col = Color(0, value + .1, 0)
	$Sprite.modulate = col