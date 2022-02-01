extends Area2D

export var speed = 750
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(ignore_layer, pos, dir):
	collision_mask = ~ignore_layer & collision_mask
	collision_layer = ignore_layer & collision_layer
	position = pos
	rotation = dir.angle()
	direction = dir
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area):
	queue_free()
