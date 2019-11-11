extends Node2D

var height:float
var moisture:float

const GROUND = {
	'water' : Vector2(-1, 0.25),
	'radioactive' : Vector2(0.6, 0.8),
}

const FEATURES = {
	'ruined city' : Vector2(.1, .13),
}

func spawn(pos:Vector2, height:float, feature:float)->void:
#	Set Position
	position = pos
	
#	Ground
	if (height <= GROUND['water'].y):
		$Ground.texture = preload("res://textures/map_textures/water_tile.png")
	elif (height >= GROUND['radioactive'].x && height <= GROUND['radioactive'].y):
		$Ground.texture = preload("res://textures/map_textures/radioactive_tile.png")
	else:
		$Ground.texture = preload("res://textures/map_textures/desert_tile.png")
	
#	Features
	if (feature > FEATURES['ruined city'].x && feature < FEATURES['ruined city'].y && height > GROUND['water'].y):
		$Feature.texture = preload("res://textures/map_textures/ruined_city_tile.png")
