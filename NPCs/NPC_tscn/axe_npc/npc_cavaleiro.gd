extends CharacterBody2D
@export var animation:AnimatedSprite2D=null
func _ready() -> void:
	animation.play("default")
