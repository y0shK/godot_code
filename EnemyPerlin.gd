extends Area2D

signal contact_made

func _ready():
	connect("contact_made", get_parent().get_node("Player"), '_on_Enemy_contact')

func _on_Enemy_contact(body):
	if body.is_in_group('Enemy'):
		emit_signal("contact_made") # Replace with function body.
		queue_free()

func _on_Enemy_body_entered(body):
	pass
