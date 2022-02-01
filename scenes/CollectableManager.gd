extends Node

signal award_points

export (PackedScene) var collectable_scene := preload("res://scenes/Collectable.tscn")

export var bronze_score = 100
export var silver_score = 250
export var gold_score = 500

export var probability_bronze = 80
export var probability_silver = 98

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func end_game():
	$SpawnTimer.stop()
	
func start_game():
	get_tree().call_group("collectables", "queue_free")
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_type():
	var value = rand_range(0, 100)
	if value <= probability_bronze:
		return "flying_bronze"
	if value <= probability_silver:
		return "flying_silver"
	else:
		return "flying_gold"
		
func get_points(type):
	if type == "flying_bronze":
		return bronze_score
	if type == "flying_silver":
		return silver_score
	else:
		return gold_score

func get_spawn_position():
	var pos = Vector2.ZERO
	pos.x = rand_range($SpawnTopLeft.position.x, $SpawnBottomRight.position.x)
	pos.y = rand_range($SpawnTopLeft.position.y, $SpawnBottomRight.position.y)
	
	return pos

func points_collected(points):
	emit_signal("award_points", points)
	pass

func spawn_collectable():
	var collectable = collectable_scene.instance()
	var type = spawn_type()
	var pos = get_spawn_position()
	
	collectable.setup(pos, 200, get_points(type), type)
	
	add_child(collectable)
	collectable.connect("collected", self, "points_collected")

func _on_SpawnTimer_timeout():
	spawn_collectable()
