extends TileMap

enum TILES {cactus,blue}

# https://www.youtube.com/watch?v=0nXWer2o980

var current_map_size = Vector2(50, 50)
export (float, 0.0, 100.0) var percentage_floors

var neighbor_directions = [Vector2(1,0), Vector2(1,1), Vector2(0,1),
	Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	
func _ready():
	randomize()
	make_map()
		
func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		smooth_map()
	if Input.is_action_just_pressed("ui_accept"):
		make_map()

func make_map():
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			var percent = rand_range(0.0, 100.0)
			if percent < percentage_floors: # arbitrary condition
				set_cell(x, y, TILES.cactus)
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
				if number_of_neighbor_walls > 4:
					set_cell(x, y, TILES.blue)
				if number_of_neighbor_walls < 4:
					set_cell(x, y, TILES.cactus)
				
				# control for having too much cactus or blue
				if lack_of_neighbor_walls >= 6:
					set_cell(x, y, TILES.blue)
				if lack_of_neighbor_walls <= 2:
					set_cell(x, y, TILES.cactus)
