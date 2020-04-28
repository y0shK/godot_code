extends Node2D

var moveSpd = 100
	
func _process(delta):
	if Input.is_action_pressed('left_up'):
		get_node('left').position.y -= moveSpd * delta
	elif Input.is_action_pressed('left_down'):
		get_node('left').position.y += moveSpd * delta
	elif Input.is_action_pressed('right_up'):
		get_node('right').position.y -= moveSpd * delta
	elif Input.is_action_pressed('right_down'):
		get_node('right').position.y += moveSpd * delta
		
	#get_node('ball').position.y -= moveSpd * delta / 2
	get_node('ball').position.x -= moveSpd * delta / 2
	
	#var ball_dir = (target_position - position).normalized
	
	if int(get_node('ball').position.x) == int(get_node('left').position.x):
		#get_node('ball').position.y += moveSpd * delta / 2
		get_node('ball').position.x += moveSpd * delta
	
	if get_node('ball').position.x < 0 or get_node('ball').position.y < 0:
		get_node('ball').position.x = -get_node('ball').position.x
