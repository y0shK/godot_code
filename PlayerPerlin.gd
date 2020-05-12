extends KinematicBody2D

var velocity = Vector2.ZERO
onready var player_sprite = get_node("Sprite")

#onready var torch_sprite = get_node("Torch")

#var state = MOVE

const MAX_SPEED = 80
const ACCELERATION = 280
const FRICTION = 280

#var transparent_sprite = ImageTexture.fix_alpha_edges(sprite)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#var enemy = preload("res://Enemy.tscn")

#disconnect("body_entered")

var enemyScene = load("res://Enemy.tscn")
var enemyInstance = enemyScene.instance()

func _on_Enemy_contact():
	#var debug_count = 0
	#debug_count += 1
	print('shulk  >cloud')
	#print(debug_count)
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	var lr = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var ud = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector.x = lr
	input_vector.y = ud
	
	#var direction_of_torch = (player_sprite.position - torch_sprite.position + Vector2(-20,20)).normalized()
	#torch_sprite.set_position(torch_sprite.position + direction_of_torch)
	
	if input_vector != Vector2.ZERO:
		if lr > 0:
			player_sprite.set_flip_h(true)
			#direction_of_torch = (player_sprite.position - torch_sprite.position + Vector2(20,20)).normalized()
		elif lr < 0:
			player_sprite.set_flip_h(false)
			#direction_of_torch = (player_sprite.position - torch_sprite.position + Vector2(-20,20)).normalized()
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = Vector2.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)	

	# check for collisions
	#enemy = Enemy.instanc
	_on_Enemy_contact()
