class_name SceneTrigger extends Area2D

@export var connected_scene: String #name of scene to change to
var scene_folder = "res://levels/scenes/level_boss"

func _on_body_entered(body):
	var full_path = scene_folder + connected_scene + ".tscn"
	var scene_tree = get_tree()
	scene_tree.call_deferred("change_scene_to_file", full_path)
