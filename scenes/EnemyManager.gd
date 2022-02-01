extends Node

signal award_points

export (PackedScene) var torpedo_scene = preload("res://scenes/Torpedo.tscn")
export (PackedScene) var tracking_torpedo_scene = preload("res://scenes/TrackingTorpedo.tscn")
export (PackedScene) var enemy_ship_scene = preload("res://scenes/EnemyPlane.tscn")

export var torpedo_min_speed = 200
export var torpedo_max_speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func end_game():
	$EnemyPlaneTimer.stop()
	$TorpedoTimer.stop()
	$TrackingTorpedoTimer.stop()
	
func start_game():
	$EnemyPlaneTimer.start()
	$TorpedoTimer.start()
	$TrackingTorpedoTimer.start()
	get_tree().call_group("enemies", "queue_free")

func unit_destroyed_by_player(points):
	emit_signal("award_points", points)

func get_spawn_position():
	var pos = Vector2.ZERO
	pos.x = rand_range($SpawnTopLeft.position.x, $SpawnBottomRight.position.x)
	pos.y = rand_range($SpawnTopLeft.position.y, $SpawnBottomRight.position.y)
	
	return pos
	
func hookup_spawn(spawn):
	add_child(spawn)
	spawn.connect("destroyed_by_player", self, "unit_destroyed_by_player")

func _on_EnemyPlaneTimer_timeout():
	launch_plane(get_spawn_position())
	
func launch_plane(pos):
	var plane = enemy_ship_scene.instance()
	plane.setup(pos)
	
	hookup_spawn(plane)
	
func launch_torpedo(pos):
	var torpedo = torpedo_scene.instance()
	torpedo.setup(pos, rand_range(torpedo_min_speed, torpedo_max_speed))
	
	hookup_spawn(torpedo)
	
func launch_tracking_torpedo(pos):
	var torpedo = tracking_torpedo_scene.instance()
	torpedo.setup(pos)
	
	hookup_spawn(torpedo)


func _on_TorpedoTimer_timeout():
	launch_torpedo(get_spawn_position())


func _on_TrackingTorpedoTimer_timeout():
	launch_tracking_torpedo(get_spawn_position())
