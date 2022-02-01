extends AnimatedSprite


var is_sound_finished
var is_animation_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	is_sound_finished = false
	is_animation_finished = false
	play()


func setup(scale_multiple):
	scale *= scale_multiple

func destroy():
	if is_sound_finished && is_animation_finished:
		queue_free()

func _on_Explosion_animation_finished():
	is_animation_finished = true
	stop()
	destroy()


func _on_AudioStreamPlayer2D_finished():
	is_sound_finished = true
	destroy()
