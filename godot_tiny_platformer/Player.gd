extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var speed = 150  # How fast the player will move (pixels/sec).
var velocity = Vector2()  # The player's movement vector. # vector 2D w/ player's movement
var screen_size  # Size of the game window.

func get_input():
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
        velocity.y += 1
	if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
		
func _physics_process(delta):
	get_input()
	move_and_slide(velocity)

func _ready():
	screen_size = get_viewport_rect().size

func start():
    #position = pos
    show() # show the player once the game starts; player is hidden by default
    $CollisionShape2D.disabled = false # un-disable collisionShape2D, the player can collide