
extends KinematicBody2D # everything KinematicBody2D can do, this script imports

var velocity = Vector2.ZERO
const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

onready var animationPlayer = $AnimationPlayer
#var animationPlayer = null
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

#func _ready():
	# animationPlayer var is a reference to the node of te same scene
	#animationPlayer = $AnimationPlayer # path to a node in the same scene
var nonzero_array = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

# underscore -> callback function - runs at runtime
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	#var last_movement_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		# just keep animationTree during movement, remembers motion direction when stopping
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Move/blend_position", input_vector)
		#animationState.travel("Idle")
		animationState.travel("Move")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		#velocity += input_vector * ACCELERATION * delta
		#velocity = velocity.clamped(MAX_SPEED)
		
		var nonzero = input_vector
		print(nonzero)
		nonzero_array.append(nonzero)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#animationPlayer.play("IdleRight")
		
		var diagonal = 0.707107
		if Vector2(diagonal, diagonal) in [nonzero_array[-3], nonzero_array[-2], nonzero_array[-1]]:
			if animationPlayer.get_current_animation() == 'IdleDown' or animationPlayer.get_current_animation() == 'IdleRight':
				animationPlayer.play('IdleDownRight')
		else:
			print(nonzero_array[-2])
			print('shulk')
			print(nonzero_array[-1])
		
		
		#if Input.is_action_just_pressed("ui_up"):
		#	animationPlayer.play("IdleUp")
		#	if Input.is_action_pressed("ui_right"):
		#		animationPlayer.play("IdleRightUp")
		
	
	#move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity) # in real-time frames, apply move_and_slide info to the velocity
	#print(last_movement_vector)

#input_vector = Vector2(1, 1)
#print(input_vector)

func get_nonzero_input_vector(vector):
	if vector != Vector2.ZERO:
		var nonzero_input_vector = vector
		return nonzero_input_vector
