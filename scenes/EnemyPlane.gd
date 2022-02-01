extends Area2D

signal destroyed_by_player

export (PackedScene) var bullet_scene
export (PackedScene) var explosion_scene := preload("res://scenes/Explosion.tscn")

export var bullet_spawn_point = Vector2.ZERO
export var speed = 200

export var health = 2
export var points = 25

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
	position += Vector2.LEFT * speed * delta

func setup(pos):
	position = pos

func spawn_bullet():
	var bullet = bullet_scene.instance()
	
	bullet.setup(collision_layer, position + bullet_spawn_point, Vector2.LEFT)
	
	get_parent().add_child(bullet)


func _on_VisibilityNotifier2D_screen_entered():
	$ShootTimer.start()
	collision_layer = desired_collision_layer
	collision_mask = desired_collision_mask


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ShootTimer_timeout():
	spawn_bullet()


func _on_EnemyPlane_area_entered(area):
	health -= 1
	
	if health <= 0:
		emit_signal("destroyed_by_player", points)
		
		var explosion = explosion_scene.instance()
		explosion.position = position
		explosion.setup(2)
		get_parent().add_child(explosion)
		
		queue_free()
