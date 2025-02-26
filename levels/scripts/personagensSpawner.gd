extends Node2D

@onready var PersonagensPosition = $Marker2D
var personagens: Node2D = null
func _ready():
	personagens = load(Global.playerDir).instantiate()
	add_child(personagens)
	personagens.global_position = PersonagensPosition.global_position
	
