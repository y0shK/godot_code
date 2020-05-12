extends Node2D

# next step: if enemy is defeated/"talked to", 
	# then water tile -> land tile and player can progress

#const WIDTH = 500
#const HEIGHT = 500

const TILES = {
	'blue': 0,
	'cactus': 1,
	'green': 2
}

onready var tileMap = get_node("TileMap")
onready var playerSprite = get_node("Player/Sprite")
onready var open_simplex_noise

var current_map_size = Vector2(50, 50)
var percentage_floors = 53

var neighbor_directions = [Vector2(1,0), Vector2(1,1), Vector2(0,1),
	Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]

var horizontal_vector = [Vector2(-1, 0), Vector2(1, 0)]
var vertical_vector = [Vector2(0, -1), Vector2(0, 1)]
var diagonal_vector1 = [Vector2(1, -1), Vector2(-1, 1)]
var diagonal_vector2 = [Vector2(-1, -1), Vector2(1, 1)]

var vector_directions = [horizontal_vector, vertical_vector, diagonal_vector1, diagonal_vector2]

func _ready():
	randomize()
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	#export var open_simplex_noise var num
	
	open_simplex_noise.octaves = 2
	open_simplex_noise.period = 10
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 0.25
	
	#_generate_world()
	make_map()

func _process(delta):
	#if Input.is_action_just_pressed("ui_right"):
		#smooth_map(open)
	#if Input.is_action_just_pressed("ui_accept"):
		#make_map()
	var player_stuck = false
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			if tileMap.get_cell(playerSprite.position.x, playerSprite.position.y) == TILES.blue:
				player_stuck = true
	if player_stuck:
		#print('shulk')
		tileMap.set_cell(playerSprite.position.x, playerSprite.position.y, TILES.cactus)
	

#func _generate_world():
#	for x in WIDTH:
#		for y in HEIGHT:
#			tileMap.set_cell(Vector2((x - WIDTH) / 2, (y - HEIGHT) /2), _get_tile_index(open_simplex_noise.get_noise_2d(float(x), float(y))))

func make_map():
	# set border to blue
	# LR
	#for x in [0, current_map_size.x - 1]:
	#	for y in current_map_size.y:
	#		tileMap.set_cell(x, y, TILES.blue)
	# UD
	#for x in current_map_size.x:
	#	for y in [0, current_map_size.y - 1]:
	#		tileMap.set_cell(x, y, TILES.blue)
	var open_simplex_noise_2d
	
	# apply noise
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			
			open_simplex_noise_2d = open_simplex_noise.get_noise_2d(float(x), float(y))
			#print(open_simplex_noise_2d)
			
			var percent = rand_range(0.0, 100.0)
			if percent < percentage_floors and open_simplex_noise_2d > 0: # arbitrary condition
				tileMap.set_cell(x, y, TILES.cactus)
			elif percent < percentage_floors and open_simplex_noise_2d < 0:
				tileMap.set_cell(x, y, TILES.green)
			else:
				tileMap.set_cell(x, y, TILES.blue)
			
			# check for sanity
			#for dir in vector_directions:
				#var neighbor_tile_array = []
				#var neighbor_tile = Vector2(x, y) + dir
				#neighbor_tile_array.append(neighbor_tile)
			
			#var neighbor_tile_count = 0
			var can_walk = 0
			var cannot_walk = 0
			for tile in neighbor_directions:
				#neighbor_tile_count += 1
				if tileMap.get_cell(tile.x, tile.y) == TILES.blue:
					cannot_walk += 1
				else:
					can_walk += 1
			
				var open_simplex_noise_2d_2 = open_simplex_noise.get_noise_2d(float(tile.x), float(tile.y))
			
				if tileMap.get_cell(x, y) == TILES.cactus or tileMap.get_cell(x, y) == TILES.green:
					if cannot_walk > 3 and open_simplex_noise_2d_2 < 0:
						tileMap.set_cell(tile.x, tile.y, TILES.cactus)
					elif cannot_walk > 3 and open_simplex_noise_2d_2 > 0:
						tileMap.set_cell(tile.x, tile.y, TILES.green)
					#if can_walk > 6:
						#tileMap.set_cell(tile.x, tile.y, TILES.blue)
				
				# no islands
				var tileLeft = Vector2(x, y) + horizontal_vector[0]
				var tileRight = Vector2(x, y) + horizontal_vector[1]
				var tileUp = Vector2(x, y) + vertical_vector[0]
				var tileDown = Vector2(x, y) + vertical_vector[1]
				
				if tileMap.get_cell(x, y) == TILES.cactus or tileMap.get_cell(x, y) == TILES.green:
					if tileMap.get_cell(tileLeft.x, tileLeft.y) == TILES.blue and tileMap.get_cell(tileRight.x, tileRight.y) == TILES.blue and tileMap.get_cell(tileUp.x, tileUp.y) == TILES.blue and tileMap.get_cell(tileRight.x, tileRight.y) == TILES.blue:
						var rand_index = rand_range(0,4)
						if rand_index == 0 and open_simplex_noise_2d_2 > 0:
							tileMap.set_cell(tileLeft.x, tileLeft.y, TILES.cactus)
						elif rand_index == 0 and open_simplex_noise_2d_2 < 0:
							tileMap.set_cell(tileLeft.x, tileLeft.y, TILES.green)
						if rand_index == 1 and open_simplex_noise_2d_2 > 0:
							tileMap.set_cell(tileRight.x, tileRight.y, TILES.cactus)
						elif rand_index == 1 and open_simplex_noise_2d_2 < 0:
							tileMap.set_cell(tileRight.x, tileRight.y, TILES.green)
						if rand_index == 2 and open_simplex_noise_2d_2 > 0:
							tileMap.set_cell(tileUp.x, tileUp.y, TILES.cactus)
						elif rand_index == 2 and open_simplex_noise_2d_2 < 0:
							tileMap.set_cell(tileUp.x, tileUp.y, TILES.green)
						if rand_index == 3 and open_simplex_noise_2d_2 > 0:
							tileMap.set_cell(tileDown.x, tileDown.y, TILES.cactus)
						if rand_index == 3 and open_simplex_noise_2d_2 < 0:
							tileMap.set_cell(tileDown.x, tileDown.y, TILES.green)
	
	#put_player_in_bounds()
	#smooth_map(open_simplex_noise_2d)

func put_player_in_bounds():
	var player_start_loc = playerSprite.position
	var player_stuck = false
	
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
			if tileMap.get_cell(player_start_loc.x, player_start_loc.y) == TILES.blue:
				player_stuck = true
				tileMap.set_cell(player_start_loc.x, player_start_loc.y, TILES.cactus)
				#if tileMap.get_cell(x, y) != TILES.blue:
				#	playerSprite.position = Vector2(x, y)
			#elif tileMap.get_cell(x, y) == TILES.blue and player_start_loc == Vector2(x,y):
			#	tileMap.set_cell(x, y, TILES.green)
	return(player_stuck)

func smooth_map(noise):
	for x in range(1, current_map_size.x - 1):
		for y in range(1, current_map_size.y - 1):
# warning-ignore:unused_variable
			#var number_of_neighbor_walls = 0
# warning-ignore:unused_variable
			#var lack_of_neighbor_walls = 0
			
			for direction in neighbor_directions:
				var neighbor_tile = Vector2(x,y) + direction # from current tile, go to the neighbor for next tile
			
			if noise < -0.1:
				tileMap.set_cell(x, y, TILES.blue)
			elif noise < 0.4 and noise > -0.1:
				tileMap.set_cell(x, y, TILES.green)
			else:
				tileMap.set_cell(x, y, TILES.cactus)
					

#func _get_tile_index(noise_sample):
#	if noise_sample < -0.1:
#		return TILES.blue
#	elif noise_sample < 0.4 and noise_sample > -0.1:
#		return TILES.cactus
#	else:
#		return TILES.green
