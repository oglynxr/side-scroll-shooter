extends Area2D

signal hit

export var speed = 400
export var starting_position = Vector2.ZERO
export var screen_offset = Vector2(10, 10)

export (PackedScene) var bullet_scene
export var bullet_spawn_point = Vector2.ZERO

export (PackedScene) var explosion_scene := preload("res://scenes/Explosion.tscn")

var max_screen_position
var min_screen_position

var is_invicible
var can_shoot


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport_rect().size
		
	var plane_size = $Plane.scale * $Plane.texture.get_size() / 2 + screen_offset
		
	min_screen_position = plane_size
	max_screen_position = screen_size - plane_size
	
	is_invicible = false
	can_shoot = true
	
func setup(pos):
	position = pos
	
func destroy():
	var explosion = explosion_scene.instance()
	explosion.position = position
	explosion.setup(2)
	get_parent().add_child(explosion)
	
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	shoot(delta)


func shoot(delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		spawn_bullet()
		$ShootTimer.start()
		can_shoot = false


func spawn_bullet():
	var bullet = bullet_scene.instance()
	
	bullet.setup(collision_layer, position + bullet_spawn_point, Vector2.RIGHT)
	
	get_parent().add_child(bullet)


func move(delta):
	var movement_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		movement_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		movement_direction.y += 1
	if Input.is_action_pressed("move_back"):
		movement_direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		movement_direction.x += 1
		
	if movement_direction.length() > 0:
		movement_direction = movement_direction.normalized()
		
	position += movement_direction * speed * delta
	position.x = clamp(position.x, min_screen_position.x, max_screen_position.x)
	position.y = clamp(position.y, min_screen_position.y, max_screen_position.y)


func _on_Player_area_entered(area):
	if !is_invicible and (area.is_in_group("enemies") or area.is_in_group("bullets")):
		emit_signal("hit")
		is_invicible = true
		$Plane.modulate.a = 0.5
		$InvicibilityTimer.start()
	
	# TODO: blink characters opacity or make animation adjusting opacity
	# give player invicibility frames for 1 second


func _on_InvicibilityTimer_timeout():
	is_invicible = false
	$Plane.modulate.a = 1.0


func _on_ShootTimer_timeout():
	can_shoot = true
