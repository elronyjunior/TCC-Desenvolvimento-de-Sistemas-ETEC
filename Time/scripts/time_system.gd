class_name TimeSystem extends Node

signal updatedTime

@export var date_time : DateTime
@export var ticks_index : int = 6
@export var ticks_pr_sec_options: Array[int] = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4196, 8392]

var is_paused : bool = false

func _process(delta: float) -> void:
	if !OS.is_debug_build():
		return
	handle_input()
	if is_paused: return
	date_time.increase_by_sec(delta * ticks_pr_sec_options[ticks_index])
	updatedTime.emit(date_time)

func handle_input() -> void:
	if Input.is_action_just_pressed("dec_speed"):
		ticks_index -= 1
	if Input.is_action_just_pressed("inc_speed"):
		ticks_index += 1
	if Input.is_action_just_pressed("pause_time"):
		is_paused = !is_paused
	
	ticks_index = clamp(ticks_index, 0, ticks_pr_sec_options.size() - 1)
