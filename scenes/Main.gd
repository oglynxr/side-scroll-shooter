extends Node

export (PackedScene) var player_scene := preload("res://scenes/Player.tscn")

export var starting_position = Vector2(200, 400)

export var max_lives = 5
export var initial_lives = 3

export var score_for_life = 1000
var score_to_next_life

var player
var player_lives
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$HUD.setup(max_lives, initial_lives)

func start_game():
	player_lives = initial_lives
	score = 0
	score_to_next_life = 0
	create_player()
	
	$EnemyManager.start_game()
	$CollectableManager.start_game()
	$HUD.start_game(player_lives)
	
	if !$GameMusic.playing:
		$GameMusic.play()
	
	get_tree().call_group("bullets", "queue_free")


func create_player():
	player = player_scene.instance()
	player.setup(starting_position)
	player.connect("hit", self, "_on_Player_hit")
	add_child(player)

func game_over():
	$Player.destroy()
	$HUD.game_over()
	$EnemyManager.end_game()
	$CollectableManager.end_game()
	
	$GameMusic.stop()

func _on_Player_hit():
	$HUD.remove_life()
	player_lives -= 1
	
	if player_lives <= 0:
		game_over()

func award_points(points):
	score += points
	score_to_next_life += points
	
	if score_to_next_life >= score_for_life:
		score_to_next_life -= score_for_life
		player_lives = min(player_lives + 1, max_lives)
		$HUD.add_life()
	
	$HUD.update_score(score)


func _on_HUD_user_reset():
	start_game()


func _on_EntryMenu_start_game():
	$EntryMenu.queue_free()
	start_game()
