extends Node2D

export (bool) var use_random_seed = true
export (int) var SEED = 0

export (float, 0, 100, 1) var octaves = 12
export (float, 0, 512, 8) var period = 128
export (float, 0, 20, .01) var lacunarity = 3
export (float, 0, 1, .01) var persistance = 0.4

const TILE_SIZE = 16
const MAP_SIZE = 64

var coord:PackedScene = preload("res://Scenes/Coordinate.tscn")
var noise_world:OpenSimplexNoise

func _ready()->void:
	if (use_random_seed):
		SEED = randi()
	z_index = -1
	noise_world = OpenSimplexNoise.new()
	noise_world.seed = SEED
	noise_world.octaves = octaves
	noise_world.period = period
	noise_world.lacunarity = lacunarity
	noise_world.persistence = persistance
	generate_map()

func generate_map()->void:
	var offset := Vector2()
	for x in range(MAP_SIZE):
		offset.x = x * TILE_SIZE
		for y in range(MAP_SIZE):
			offset.y = y * TILE_SIZE
			var dist = Vector2(x, y).distance_to(Vector2(MAP_SIZE * .5, MAP_SIZE * .5))
			if (dist != 0):
				dist = (MAP_SIZE * .15) / dist
			else:
				dist = 2
			spawn_coord(offset, dist * ((noise_world.get_noise_2dv(offset) + 1) * .5))

func spawn_coord(pos:Vector2, value:float)->void:
	var new_coord = coord.instance()
	new_coord.spawn(pos, value)
	add_child(new_coord)

func _process(delta):	
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()