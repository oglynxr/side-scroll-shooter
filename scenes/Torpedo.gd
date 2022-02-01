extends Area2D

signal destroyed_by_player

export var points = 10
export (PackedScene) var explosion_scene := preload("res://scenes/Explosion.tscn")

var velocity = Vector2.ZERO

var desired_collision_layer
var desired_collision_mask

# Called when the node enters the scene tree for the first time.
func _ready():
	desired_collision_layer = collision_layer
	desired_collision_mask = collision_mask
	
	collision_layer = 0
	collision_mask = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

func setup(pos, speed):
	position = pos
	velocity = Vector2.LEFT * speed;

func _on_VisibilityNotifier2D_screen_entered():
	collision_layer = desired_collision_layer
	collision_mask = desired_collision_mask


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Torpedo_area_entered(area):
	if area.get_name() != "Player":
		emit_signal("destroyed_by_player", points)
		
	var explosion = explosion_scene.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	
	queue_free()
