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
var height_map:OpenSimplexNoise
var temperature_map:OpenSimplexNoise
var percipitation_map:OpenSimplexNoise

func _ready()->void:
	if (use_random_seed):
		SEED = randi()
	z_index = -1
	height_map = init_noise(SEED, octaves, period, lacunarity, persistance)
	temperature_map = init_noise(SEED / 13.173213, octaves, period, lacunarity, persistance)
	generate_map()

func init_noise(n_seed:float, n_oct:float, 
	n_period:float, n_lac:float, n_pers:float)->OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.seed = n_seed
	noise.octaves = n_oct
	noise.period = n_period
	noise.lacunarity = n_lac
	noise.persistence = n_pers
	return noise

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
			spawn_coord(offset, dist * ((height_map.get_noise_2dv(offset) + 1) / 2))

func spawn_coord(pos:Vector2, height:float)->void:
	var new_coord = coord.instance()
	new_coord.spawn(pos, height, randf())
	add_child(new_coord)

func _process(delta):	
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()