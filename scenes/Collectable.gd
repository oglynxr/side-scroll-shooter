extends Area2D

signal collected

var points_to_award
var has_entered_screen
var speed
var has_been_collected


# Called when the node enters the scene tree for the first time.
func _ready():
	has_entered_screen = false
	has_been_collected = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.LEFT * speed * delta


func setup(pos, target_speed, points, type):
	position = pos
	speed = target_speed
	points_to_award = points
	$AnimatedSprite.play(type)


func _on_Collectable_area_entered(area):
	if !has_been_collected:
		has_been_collected = true
		$AnimatedSprite.hide()
		
		$AudioStreamPlayer2D.play()
		
		emit_signal("collected", points_to_award)


func _on_VisibilityNotifier2D_screen_entered():
	has_entered_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AudioStreamPlayer2D_finished():
	queue_free()
