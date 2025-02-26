extends Resource
class_name  PlayerData
var save_path=str("user://data/save_game_",3,".tres")
@export var player_name:String
@export var player_class:String
@export var player_nivel:int
@export var player_texture:String="res://Player/icon_skills/empty.png"
@export var save_slot:int
@export var player_status=[]
@export var Save_Player_Position:Vector2
@export var curent_scene:String
@export var screenshot_load:int
@export var Vitalidade:int
@export var Defesa:int
@export var Forca:int
@export var Sorte:int
@export var Inteligencia:int
@export var XP:int

func Update_posision(position:Vector2):
	Save_Player_Position=position
func create_basic_save(name:String,p_class:String,stat:Array,slot:int):
	player_name=name
	player_class=p_class
	player_nivel=0
	player_texture="res://Player/icon_skills/empty.png"
	curent_scene="res://cenas/Tutorial/Tutorial.tscn"
	save_slot=slot
	player_status=stat
	Vitalidade=0
	Defesa=0
	Forca=0
	Sorte=0
	Inteligencia=0
	XP=0
	
	#key_binds={"0": "Q","1": "E","2": "R","attack": "J","baixo": "S","cima": "W","direita": "D","esquerda": "A","save": "N"}
	Save_Player_Position=Vector2(-182,-13)
	save_game()
func save_print(N:int):
	screenshot_load=N
	
func save_game():
	ResourceSaver.save(self,save_path)
	
func load_game(load_path:String):
	var saved_data = ResourceLoader.load(load_path)
	var loaded_data = saved_data as PlayerData
	return loaded_data
