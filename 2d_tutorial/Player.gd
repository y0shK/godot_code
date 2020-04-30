extends Area2D
signal hit # defines a custom symbol called hit when the player contacts an enemy

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# export puts the value into the inspector, can tinker with it in real-time
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	screen_size = get_viewport_rect().size

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# using delta ensures that movement stays the same even if framerate changes
	# Update game logic here.
	#pass
	var velocity = Vector2()  # The player's movement vector. # vector 2D w/ player's movement
	if Input.is_action_pressed("ui_right"):
        velocity.x += 1
	if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
        velocity.y += 1
	if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
	if velocity.length() > 0: # is a button being pressed?
		# due to vector addition, left-right and up-down create a hypotenuse of sqrt(2), or 1.4
		# don't want the player to move faster diagonally, so we normalize the vector - i.e. turn it back to 1
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play() # $ is a relative path, same as get_node(animatedSprite)
	else:
        $AnimatedSprite.stop()
		
	# clamp values to restrict the amount the player can move in any given direction
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x < 0:
    	$AnimatedSprite.flip_h = true
	else:
    	$AnimatedSprite.flip_h = false
		
	#if velocity.y < 0:
	#	$AnimatedSprite.flip_v = true
	#else:
	#	$AnimatedSprite.flip_v = false

func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit") # call custom-made function from node menu
	# error can occur if collision disable happens when collision occurs - Godot safeguards against this with set_deferred

# start a new game
func start(pos):
    position = pos
    show() # show the player once the game starts; player is hidden by default
    $CollisionShape2D.disabled = false # un-disable collisionShape2D, the player can collide



