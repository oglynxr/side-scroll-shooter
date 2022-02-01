extends Area2D

signal destroyed_by_player

export (PackedScene) var explosion_scene := preload("res://scenes/Explosion.tscn")

export var speed = 400
export var points = 35
export var maximum_turn_angle = PI / 2

var desired_collision_layer
var desired_collision_mask

var player
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	desired_collision_layer = collision_layer
	desired_collision_mask = collision_mask
	
	collision_layer = 0
	collision_mask = 0

func setup(pos):
	position = pos
	direction = Vector2.LEFT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		var angle = clamp(
			direction.angle_to(player.position - position), 
			-maximum_turn_angle * delta, 
			maximum_turn_angle * delta)
		
		direction = direction.rotated(angle)
		rotation += angle
	
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_entered():
	collision_layer = desired_collision_layer
	collision_mask = desired_collision_mask


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_TrackingTorpedo_area_entered(area):
	if area.get_name() != "Player":
		emit_signal("destroyed_by_player", points)
		
	var explosion = explosion_scene.instance()
	explosion.position = position
	get_parent().add_child(explosion)
		
	queue_free()


func _on_TrackingZone_area_entered(area):
	if area.get_name() == "Player":
		player = area


func _on_TrackingZone_area_exited(area):
	if area.get_name() == "Player":
		player = null
