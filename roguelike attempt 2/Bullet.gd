extends Area2D

const SPEED = 200
var direction = Vector2()

func _physics_process(delta):
	translate(direction * SPEED * delta)


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_area_entered(area):
	if area.is_in_group('Enemy'):
		area.queue_free()
