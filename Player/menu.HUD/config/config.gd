extends Control
class_name Config
@onready var config = $".."
@export var Btn_Keys:VBoxContainer=null
@export var HboxContainer:HBoxContainer=null
@export var margin_container:MarginContainer=null
@export var label_panel:Label=null
var configData=ConfigData.new()
var load_inputs=configData.load_game()
var tema_input:=preload("res://Player/menu.HUD/temas/default.tres")
var inputs=[]
var dicionario={}
var tecla=" "
var default_key_binds = {
	"move_up": "w",
	"move_down": "s",
	"move_left": "a",
	"move_right": "d",
	"attack": "q",
	"inventory": "i",
	"use_item": "u",
	"move_selector": "tab",
	"interagir": "e",
	"character_sheet": "c"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	create_inputs()
	#print(inputs)
	load_key_binds()
	create_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#font_size_flex()
	pass

func font_size_flex():
	for labels in Global.acha_filhos("Label"):
		labels["theme_override_font_sizes/font_size"]=Global.proporcional(30,40)

func _on_btn_quit_pressed():
	save_key_binds()
	configData.save_game()
	get_parent().visible=true
	Global.navigation=false
	queue_free()

func create_btn():
	pass

func create_inputs():
	var x:int=-1
	for i in InputMap.get_actions():
		x+=1
		if(x>76 && x<87):
			inputs.append(i)

func create_list():
	for elementos in inputs:
		var hbox=HBoxContainer.new()
		var label=Label.new()
		var btn_key=Button.new()
		hbox.name=str("Hbox_",elementos)
		label.name=str("label_",elementos)
		btn_key.name=str("btn_",elementos)
		label.text=elementos.replace("_"," ")
		label.theme=tema_input
		btn_key.theme=tema_input
		label.custom_minimum_size.x=160
		label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		btn_key.custom_minimum_size.x=100
		btn_key.text=acha_tecla(elementos)
		var func_ref = get(str("_",elementos))
		if(func_ref != null):	
			var separator:=VSeparator.new()
			separator.theme=tema_input
			btn_key.pressed.connect(func_ref)
			Btn_Keys.add_child(hbox)
			hbox.add_child(label)
			hbox.add_child(btn_key)
			Btn_Keys.add_child(separator)
func _input(event):
	if(margin_container.visible && not event is InputEventMouseMotion && not event is InputEventMouseButton):
		var redundancia=false
		for i in inputs:
			if acha_input(str(event)) == acha_tecla(i):
				redundancia=true
		if(redundancia):
			label_panel.text="esta tecla já esta em uso!"
		if(!redundancia):
			label_panel.text="aperte um input valido..."
			InputMap.action_erase_events(tecla)
			InputMap.action_add_event(tecla,event)
			var btn_name=get_node(str(Btn_Keys.get_path(),"/Hbox_",tecla,"/btn_",tecla))
			btn_name.text=acha_tecla(tecla)
			margin_container.visible=false
func createpanel():
	margin_container.visible=true
func _move_up():
	tecla="move_up"
	createpanel()
func _move_down():
	tecla="move_down"
	createpanel()
func _move_left():
	tecla="move_left"
	createpanel()
func _move_right():
	tecla="move_right"
	createpanel()
func _attack():
	tecla="attack"
	createpanel()
func _inventory():
	tecla="inventory"
	createpanel()
func _use_item():
	tecla="use_item"
	createpanel()
func _move_selector():
	tecla="move_selector"
	createpanel()
func _interagir():
	tecla="interagir"
	createpanel()
func _character_sheet():
	tecla="character_sheet"
	createpanel()

func _on_button_pressed():
	label_panel.text="aperte um input valido..."
	margin_container.visible=false

func acha_tecla(elementos:String):
	var achou:bool=false
	for i in str(InputMap.action_get_events(elementos)):
			if(achou):
				return i
			if(i=="("):
				achou=true
	return "não achou"

func acha_input(input:String):
	var achou:bool=false
	for i in input:
			if(achou):
				return i
			if(i=="("):
				achou=true
	return "não achou"
	
func save_key_binds():
	for input in inputs:
		configData.key_binds[input]=acha_tecla(input)

func load_key_binds():
	for i in load_inputs.key_binds:  # Supondo que `inputs` seja uma lista de ações
		var key_string = load_inputs.key_binds[i]  # Supondo que acha_tecla retorna a string da tecla desejada
		var code = OS.find_keycode_from_string(key_string)
		var event = InputEventKey.new()
		event.keycode=code
		#InputMap.action_erase_events(i)
		#InputMap.action_add_event(i, event)

func update_buttons():
	for elementos in inputs:
		var btn_key = get_node(str(Btn_Keys.get_path(), "/Hbox_", elementos, "/btn_", elementos))
		if btn_key:
			btn_key.text = acha_tecla(elementos)  # Atualiza o texto do botão para a tecla atual

func reset_key_binds():
	# Limpar o mapeamento atual de teclas
	for input in inputs:
		InputMap.action_erase_events(input)
	print(default_key_binds.keys())
	# Restaura os valores padrões
	for action in default_key_binds.keys():
		var key_string = default_key_binds[action]
		var code = OS.find_keycode_from_string(key_string)
		var event = InputEventKey.new()
		event.keycode = code
		InputMap.action_add_event(action, event)

	# Atualiza os botões para refletir as teclas restauradas
	update_buttons()

func _on_btn_reset_pressed() -> void:
	reset_key_binds()
	label_panel.text = "Teclas restauradas ao padrão."
