extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player_essentials()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Player_essentials() ->void:
	Global.slot=1
	var player = load("res://Player/player.tscn").instantiate()
	get_parent().add_child.call_deferred(player)
func _process(_delta: float) -> void:
	pass
