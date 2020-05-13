# from signal video - https://www.youtube.com/watch?v=drw8xX7l8zc

extends Node2D

func _on_Enemy_body_entered(body):
	if body.is_in_group('Player'):
		print('groups work')
		body.queue_free()
		SceneChanger.change_scene("res://WorldToChangeTo.tscn")
		
#change_scene("BindingOfIsaac.tscn")
