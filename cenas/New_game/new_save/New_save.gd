extends Control
class_name New_save
var class_selected: int = 1
@export var slot: int = Global.slot
@export var name_input: LineEdit = null
@export var animation: AnimatedSprite2D = null
@export var label_class: Label = null

var btn_selected = 0
var classes = Classes.new().classes
var total_classes = classes.size()
var obj_playerdata = PlayerData.new()

var guerreiro = "res://character/scenes/character.tscn"
var lanceiro = "res://character/scenes/lanceiro.tscn"
var feiticeira = "res://character/scenes/feiticeira.tscn"
var arqueira = "res://character/scenes/arqueira.tscn"

func _ready():
	get_node("HBoxContainer/VBoxContainer4/PanelContainer/VBoxContainer/MarginContainer/VboxClass/Button1")["button_pressed"] = true
	animation.play("Arqueira")
	Global.playerDir = arqueira
	StatusPlayer.selected_class = 0
	get_viewport().size_changed.connect(text_change)
	print(classes[0][1][0])

func _process(_delta):
	label_class.text = classes[btn_selected][0]

func text_change():
	for i in range(4):
		var label = get_node(str("HBoxContainer/VBoxContainer4/PanelContainer/VBoxContainer/MarginContainer/VboxClass/Button", i + 1))
		label["theme_override_font_sizes/font_size"] = Global.proporcional(16, 35)
	get_node("HBoxContainer/VBoxContainer3/VBoxContainer2/class")["theme_override_font_sizes/font_size"] = Global.proporcional(36, 50)
	get_node("HBoxContainer/VBoxContainer4/PanelContainer/VBoxContainer/PanelContainer/text_class")["theme_override_font_sizes/font_size"] = Global.proporcional(16, 35)
	get_node("HBoxContainer/VBoxContainer/name")["theme_override_font_sizes/font_size"] = Global.proporcional(31, 55)

func _on_button_pressed():
	if name_input.text.strip_edges() == "":
		return
	creat_save()
	#get_tree().change_scene_to_file("res://levels/scenes/test_level.tscn")
	get_tree().change_scene_to_file("res://levels/scenes/castelo_level1.tscn")
	MusicController.play_SfxBtnConfirm()

func creat_save():
	# Definir os status iniciais com base na classe selecionada
	var selected_stats = classes[btn_selected][1]  # Array de status da classe escolhida
	StatusPlayer.set_initial_stats(selected_stats)
	
	obj_playerdata.save_path = str("user://data/", Global.email, "/save_game_", Global.slot, ".tres")
	obj_playerdata.create_basic_save(name_input.text, classes[btn_selected][0], classes[btn_selected][1], Global.slot)

func get_status_classe():
	var status_container = get_node("HBoxContainer/VBoxContainer")
	var indice: int = 0
	for valores in Global.acha_filhos("Label", ["Label", "LblVitalidade", "LblDefesa", "LblForca", "LblSorte", "LblInteligencia"], status_container):
		valores.text = str(classes[btn_selected][1][indice])
		indice += 1

func btn_class_1(): # Arqueira
	btn_selected = 0
	get_status_classe()
	animation.play("Arqueira")
	Global.playerDir = arqueira
	StatusPlayer.selected_class = 0

func btn_class_2(): # Guerreiro
	btn_selected = 1
	get_status_classe()
	animation.play("Guerreiro")
	Global.playerDir = guerreiro
	StatusPlayer.selected_class = 1
	
func btn_class_3(): # Feiticeira
	btn_selected = 2
	get_status_classe()
	animation.play("Feiticeira")
	Global.playerDir = feiticeira
	StatusPlayer.selected_class = 2

func btn_class_4(): # Lanceiro
	btn_selected = 3
	get_status_classe()
	animation.play("Lanceiro")
	Global.playerDir = lanceiro
	StatusPlayer.selected_class = 3

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/New_game/slots/select_save.tscn")
	MusicController.play_SfxBtnCancel()
