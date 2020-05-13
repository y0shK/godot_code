# https://www.youtube.com/watch?v=_4_DVbZwmYc
# additional notes: added as autoload script in project settings, etc. - see video

extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var Black = $Control/Black

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("FadeOut")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("FadeOut")
