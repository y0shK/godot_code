extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()] # randomly choose 1 of 3 animation types

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # delete mobs when they leave the screen

