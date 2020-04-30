extends Node

export (PackedScene) var Obstacle
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	$Player.start()
	var mushroom = Obstacle.instance()
	add_child(mushroom)
	#var tree_background = reddit_background.instance()
	#add_child(tree_background)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
