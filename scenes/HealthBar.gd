extends GridContainer

export (PackedScene) var icon_scene := preload("res://scenes/HealthIcon.tscn")

var max_lives = 3
var lives_remaining
var lives

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_lives(max_lives, starting_lives):
	self.max_lives = max_lives
	lives_remaining = starting_lives
	columns = self.max_lives
	
	populate_icons()
	hide_extra_lives()
	
func hide_extra_lives():
	for i in range(lives_remaining, max_lives):
		lives[i].hide()
	pass
		
func populate_icons():
	lives = []
	for life in range(max_lives):
		var icon = create_health_icon()
		lives.append(icon)
	
func create_health_icon():
	var health_icon = icon_scene.instance()
	add_child(health_icon)
	
	return health_icon

func remove_life():
	lives_remaining = max(lives_remaining - 1, 0)
	
	lives[lives_remaining].hide()
	
func add_life():
	if lives_remaining < max_lives:
		lives[lives_remaining].show()
	
	lives_remaining = min(lives_remaining + 1, max_lives)
	
func reset_lives(lives_remaining):
	self.lives_remaining = lives_remaining
	
	for i in range(lives_remaining):
		lives[i].show()
