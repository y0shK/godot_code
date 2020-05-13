extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Enemy_body_entered(body): # this line has the green marker, indicating that the function is passed through a signal
	if body.is_in_group('Player'):
		print('groups work')
		body.queue_free()
