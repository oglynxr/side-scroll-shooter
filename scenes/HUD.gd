extends CanvasLayer

signal user_reset

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayAgainButton.hide()
	$Message.hide()
	$HealthBar.hide()
	$ScoreText.hide()
	$QuitButton.hide()
	
	
func setup(max_lives, lives):
	$HealthBar.set_lives(max_lives, lives)
	
func start_game(lives):
	$ScoreText.text = str(0)
	$HealthBar.reset_lives(lives)
	
	$Message.hide()
	$PlayAgainButton.hide()
	$QuitButton.hide()
	
	$ScoreText.show()
	$HealthBar.show()
	
func game_over():
	$Message.text = "Game Over"
	$Message.show()
	$PlayAgainButton.show()
	$QuitButton.show()

func update_score(score):
	$ScoreText.text = str(score)
	
func remove_life():
	$HealthBar.remove_life()
	
func add_life():
	$HealthBar.add_life()


func _on_PlayAgainButton_pressed():
	emit_signal("user_reset")


func _on_QuitButton_pressed():
	get_tree().quit()
