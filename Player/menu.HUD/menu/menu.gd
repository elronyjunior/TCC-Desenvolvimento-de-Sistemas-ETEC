extends CanvasLayer
class_name Menu
@onready var menu = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	menu.visible=false

func _physics_process(_delta: float) -> void:
	pass

func _unhandled_input(event):
	if(event.is_action_pressed("pause") && Global.navigation == false):
		menu.visible=!menu.visible
		get_tree().paused=!get_tree().paused

func _on_btn_resume_pressed():
	menu.visible=false
	get_tree().paused=false
	MusicController.play_SfxBtnConfirm()

func _on_btn_config_pressed():
	var config:= preload("res://cenas/Config_Menu/Config_menu.tscn").instantiate()
	Global.navigation=true
	menu.add_child(config)
	MusicController.play_SfxBtnConfirm()

func _on_btn_quit_pressed():
	get_tree().quit()
	MusicController.play_SfxBtnCancel()

func _on_btn_screenshot_pressed():
	menu.visible=false
	await tirarPrint()
	menu.visible=true
	MusicController.play_SfxBtnConfirm()
 
func tirarPrint():
	var name_img:String
	var DatePC=Time.get_datetime_dict_from_system()
	for T in DatePC:
		if(T!="second" && T!="dst"):
			name_img+=str(DatePC[T],"_")
		if(T=="second"):
			name_img+=str(DatePC[T])
	await RenderingServer.frame_post_draw
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png(str("user://data/",Global.email,"/img_saves/",name_img,".png"))
