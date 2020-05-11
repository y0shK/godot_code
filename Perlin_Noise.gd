working Perlin

extends Node2D

const TILES = {
	'blue': 0,
	'cactus': 1,
	'green': 2
}

onready var tileMap = get_node("TileMap")
onready var open_simplex_noise

var current_map_size = Vector2(50, 50)
var percentage_floors = 53

func _ready():
	randomize()
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	
	open_simplex_noise.octaves = 2
	open_simplex_noise.period = 10
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 0.25
	
	make_map()

func make_map():

	var open_simplex_noise_2d
	
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			
			open_simplex_noise_2d = open_simplex_noise.get_noise_2d(float(x), float(y))
			
			var percent = rand_range(0.0, 100.0)
			if percent < percentage_floors and open_simplex_noise_2d > 0: # arbitrary condition
				tileMap.set_cell(x, y, TILES.cactus)
			elif percent < percentage_floors and open_simplex_noise_2d < 0:
				tileMap.set_cell(x, y, TILES.green)
			else:
				tileMap.set_cell(x, y, TILES.blue)			
