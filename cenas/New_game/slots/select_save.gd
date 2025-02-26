extends Control
@export var vbox:VBoxContainer=null
@export var slot:int
var caminho ="user://data/save_game_"
# Called when the node enters the scene tree for the first time.
func _ready():
	verifica_loads()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func verifica_loads():
	var exist =false
	for i in range(3):
		if(save_exists(str("user://data/",Global.email,"/save_game_",i+1,".tres"))):
			exist=true
			creat_saves(exist,str(i+1))
		else:
			exist=false
			creat_saves(exist,str(i+1))
	
func creat_saves(exist:bool,name_save:String):
	if(!exist):
		var new_game_slot=preload("res://cenas/New_game/slots/new_game_btn.tscn").instantiate()
		new_game_slot.name=str("slot_",name_save)
		var func_ref = get(str("btn_save_",name_save))
		new_game_slot.get_node("Button").pressed.connect(func_ref)
		vbox.add_child(new_game_slot)
		var separa= HSeparator.new()
		separa.custom_minimum_size=Vector2(271,30)
		separa.theme=preload("res://cenas/load game/load_tema.tres")
		vbox.add_child(separa)
	if(exist):
		var load_obj=load_game(str("user://data/",Global.email,"/save_game_",name_save,".tres"))
		var load_slot=preload("res://cenas/load game/Panel_select_load.tscn").instantiate()
		load_slot.name=str("slot_",name_save)
		load_slot.get_node("MarginContainer/save/HBoxContainer/nivel").text=str(load_obj.player_nivel)
		load_slot.get_node("MarginContainer/save/VBoxContainer/Name").text=load_obj.player_name
		load_slot.get_node("MarginContainer/save/VBoxContainer/class").text=load_obj.player_class
		load_slot.get_node("MarginContainer/save/mini_picture").texture=load(str("res://data/img_save/",name_save,".png"))
		var func_ref = get(str("btn_save_",name_save))
		load_slot.get_node("Button").pressed.connect(func_ref)
		vbox.add_child(load_slot)
		var separa= HSeparator.new()
		separa.custom_minimum_size=Vector2(271,30)
		separa.theme=preload("res://cenas/load game/load_tema.tres")
		vbox.add_child(separa)
	
func new_save_title(slt_n:int):
	var cena=preload("res://cenas/New_game/new_save/new_save.tscn")
	Global.slot=slt_n
	get_tree().change_scene_to_file(cena.resource_path)
func save_exists(path: String) -> bool:
	return FileAccess.file_exists(path)
func load_game(save_path:String):
	var saved_data = ResourceLoader.load(save_path)
	var loaded_data = saved_data as PlayerData
	return loaded_data

func btn_save_1():
	print("new save 1")
	new_save_title(1)
func btn_save_2():
	print("new save 2")
	new_save_title(2)
func btn_save_3():
	print("new save 3")
	new_save_title(3)


func _on_btn_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/title screem/title_screem.tscn")
	MusicController.play_SfxBtnCancel()
