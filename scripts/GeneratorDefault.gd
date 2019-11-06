extends Node2D


export(int) var Seed;


onready var groundmap = $GroundMap;
onready var wallmap = $WallMap;

export var LevelSize = 64;
export (float, 0, 100, 1) var Octaves = 12
export (float, 0, 512, 8) var Period = 128
export (float, 0, 20, .01) var Lacunarity = 3
export (float, 0, 1, .01) var Persistance = 0.4

export var bound_height = 35;
export var bound_width = 70;
export var wall_min = 0.2;

var noise_gen:OpenSimplexNoise

# Called when the node enters the scene tree for the first time.
func _ready():
	noise_gen = OpenSimplexNoise.new();
	noise_gen.seed = Seed;
	noise_gen.octaves = Octaves;
	noise_gen.period = Period;
	noise_gen.lacunarity = Lacunarity;
	noise_gen.persistence = Persistance;
	generate_world()
	generate_bounds()
	wallmap.update_bitmask_region();
	groundmap.update_bitmask_region()

func generate_bounds():
	for y in range(bound_height):
		for x in range(LevelSize + (bound_width * 2)):
			wallmap.set_cell(x - bound_width, -1 - y, 0);
			wallmap.set_cell(x - bound_width, LevelSize + y, 0);
	for x in range(bound_width):
		for y in range(LevelSize):
			wallmap.set_cell(-1 - x, y, 0);
			wallmap.set_cell(LevelSize + x, y, 0);
	

func generate_world():
	for x in range(LevelSize):
		for y in range(LevelSize):
			var noise_val = noise_gen.get_noise_2d(x, y);
			if (noise_val < wall_min):
				pass
			else:
				wallmap.set_cell(x, y, 0);
			groundmap.set_cell(x, y, 0);
	
	