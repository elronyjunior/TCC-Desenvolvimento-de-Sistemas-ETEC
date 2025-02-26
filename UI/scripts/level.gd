extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Update_level() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Update_level()

func Update_level() -> void:
	text="Level: " + str(LevelManager.player_level)
