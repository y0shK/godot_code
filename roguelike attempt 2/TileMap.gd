extends TileMap

enum TILES {cactus,blue,green}

# https://www.youtube.com/watch?v=0nXWer2o980
# with noise added

var current_map_size = Vector2(50, 50)
var percentage_floors = 53

var neighbor_directions = [Vector2(1,0), Vector2(1,1), Vector2(0,1),
	Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]

onready var open_simplex_noise
onready var open_simplex_noise2d
	
func _ready():
	randomize()
	
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	#export var open_simplex_noise var num
	
	open_simplex_noise.octaves = 2
	open_simplex_noise.period = 10
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 0.25
	
	make_map()
		
func _process(_delta):
	pass

func make_map():
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			
			open_simplex_noise2d = open_simplex_noise.get_noise_2d(float(x), float(y))
			
			var percent = rand_range(0.0, 100.0)
			if percent < percentage_floors and open_simplex_noise2d < 0: # arbitrary condition
				set_cell(x, y, TILES.cactus)
			elif percent > percentage_floors and open_simplex_noise2d > 0:
				set_cell(x, y, TILES.green)
			else:
				set_cell(x, y, TILES.blue)
				
	# set border to blue
	# LR
	for x in [0, current_map_size.x - 1]:
		for y in current_map_size.y:
			set_cell(x, y, TILES.blue)
	# UD
	for x in current_map_size.x:
		for y in [0, current_map_size.y - 1]:
			set_cell(x, y, TILES.blue)

func smooth_map():
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			var number_of_neighbor_walls = 0
			var lack_of_neighbor_walls = 0
			for direction in neighbor_directions:
				var neighbor_tile = Vector2(x,y) + direction # from current tile, go to the neighbor for next tile
				if get_cell(neighbor_tile.x, neighbor_tile.y) == TILES.blue:
					number_of_neighbor_walls += 1
				if get_cell(neighbor_tile.x, neighbor_tile.y) == TILES.cactus:
					lack_of_neighbor_walls += 1
				
				# should we change the current tile based on how many neighboring tiles there are?
				if number_of_neighbor_walls > 4 and open_simplex_noise2d > 0:
					set_cell(x, y, TILES.green)
				if number_of_neighbor_walls < 4 and open_simplex_noise2d < 0:
					set_cell(x, y, TILES.cactus)
				
				# control for having too much cactus, green, or blue
				if lack_of_neighbor_walls >= 6:
					set_cell(x, y, TILES.blue)
				if lack_of_neighbor_walls <= 2 and open_simplex_noise2d < 0:
					set_cell(x, y, TILES.cactus)
				elif lack_of_neighbor_walls <= 2 and open_simplex_noise2d > 0:
					set_cell(x, y, TILES.green)
