extends Control
@export var animation:AnimationPlayer=null
# Called when the node enters the scene tree for the first time.
func _ready():
	check_continue()
	animation.play("fade_in")
	MusicController.play_music()

func check_continue():
	var btn_continue=get_node("HBoxContainer/VBoxContainer/VBoxContainer/btn_continue")
	var separator=get_node("HBoxContainer/VBoxContainer/VBoxContainer/HSeparator")
	for i in range(3):
		if(FileAccess.file_exists(str("user://data/",Global.email,"/save_game_",i+1,".tres"))):
			btn_continue.visible=true
			separator.visible=true
func _on_btn_quit_pressed():
	get_tree().quit()
	MusicController.play_SfxBtnCancel()


func _on_btn_continue_pressed():
	get_tree().change_scene_to_file("res://cenas/load game/select_load.tscn")
	MusicController.play_SfxBtnConfirm()


func _on_btn_new_game_pressed():
	get_tree().change_scene_to_file("res://cenas/New_game/slots/select_save.tscn")
	MusicController.play_SfxBtnConfirm()


func _on_config_pressed():
	get_node(".").add_child(load("res://cenas/Config_Menu/Config_menu.tscn").instantiate())
	MusicController.play_SfxBtnConfirm()
