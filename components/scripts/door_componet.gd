extends Area2D
class_name DoorComponents

var _player_ref: Character = null
@export_category("Variables")
@export var _teleport_position: Vector2

@export_category("Objects")
@onready var _animation = $Animation

var _is_player_inside = false
var _animation_started = false

func _on_body_entered(_body):
	if _body is Character:
		_player_ref = _body
		_is_player_inside = true
		print("Player entered, teleport position: ", _teleport_position)

func _process(_delta):
	if _is_player_inside and _player_ref != null and Input.is_action_just_pressed("interagir") and not _animation_started:
		_animation.play("open")
		_animation_started = true
		print("Animation started")

func _on_animation_finished(_anim_name: String) -> void:
	if _anim_name == "open":
		if _is_player_inside and _player_ref != null:
			print("Teleporting player to: ", _teleport_position)
			_player_ref.global_position = _teleport_position
			_animation.play("close")
		else:
			print("Animation finished but conditions not met: ", _is_player_inside, _player_ref != null)
		_animation_started = false
	elif _anim_name == "close":
		_animation_started = false

func _on_body_exited(_body):
	if _body is Character and _body == _player_ref:
		_is_player_inside = false
		_player_ref = null
		print("Player exited")
