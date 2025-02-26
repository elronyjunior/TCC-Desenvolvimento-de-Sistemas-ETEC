extends Control
@export var img_icon:TextureRect=null
@export var tab_inicial:VBoxContainer
@export var VBoxControles:VBoxContainer=null
@export var option_button: OptionButton = null # O OptionButton onde o usuário escolhe a resolução
@export var option_button2: OptionButton = null # O OptionButton onde o usuário escolhe o modo de tela
@export var hslider: HSlider = null  # O HSlider para ajustar o brilho
@onready var som : SOM

var default_brightness: float = 1.0  # Valor padrão do brilho
var default_volumes: Array = []

# Tamanhos de tela possíveis
const RESOLUTION_DICTIONARY: Dictionary = {
	"1920x1080": Vector2(1920, 1080),
	"1280x720": Vector2(1280, 720),
	"800x480": Vector2(800, 480)
}
const WINDOW_MODE_ARRAY: Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]

func _ready() -> void:
	tab_inicial.visible=true
	Controles()
	option_button2.item_selected.connect(on_window_mode_selected)
	add_window_mode_items()
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	# Inicializa default_volumes apenas se ainda não estiver definido
	if Global.default_volumes == []:
		for i in range(AudioServer.get_bus_count()):
			Global.default_volumes.append(AudioServer.get_bus_volume_db(i))  # Salva os volumes padrãofunc _process(_delta: float) -> void:
pass

func Controles():
	var config_buttons:=preload("res://Player/menu.HUD/config/config_controles.tscn")

func _on_btn_tela_pressed() -> void:
	habilita_tab("Tela")
	MusicController.play_SfxBtnConfirm()

func _on_btn_som_pressed() -> void:
	habilita_tab("Som")
	MusicController.play_SfxBtnConfirm()
func _on_btn_controles_pressed() -> void:
	habilita_tab("Controles")
	MusicController.play_SfxBtnConfirm()
func _on_btn_ajuda_pressed() -> void:
	habilita_tab("Ajuda")
	MusicController.play_SfxBtnConfirm()
func habilita_tab(tab:String):
	get_node(str("lados/ScrolTab/TabContainer/VBox",tab)).visible=true
	var icone=get_node(str("lados/VBoxPai/HBoxContainer/VBoxBtn/Btn",tab)).icon
	img_icon.texture=icone
func _on_texture_button_pressed() -> void:
	Global.navigation=false
	get_parent().visible=true
	queue_free()
	MusicController.play_SfxBtnCancel()

# Função chamada quando o valor do HSlider muda
func _on_hslider_value_changed(value: float) -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = value

func _on_reset_brilho_pressed() -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = default_brightness  # Reseta o brilho
	if hslider != null:
		hslider.value = default_brightness  # Atualiza a posição do slider
	MusicController.play_SfxBtnConfirm()

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY.keys():
		option_button.add_item(resolution_size_text)

func on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button2.add_item(window_mode)

func on_window_mode_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _on_button_Mutar_pressed() -> void:
	for i in range(AudioServer.get_bus_count()):
		AudioServer.set_bus_volume_db(i, -80)  # Define o volume de todos os barramentos para o mínimo
	_update_sliders()
	MusicController.play_SfxBtnConfirm()

func _on_btn_alto_pressed() -> void:
	for i in range(AudioServer.get_bus_count()):
		AudioServer.set_bus_volume_db(i, Global.default_volumes[i])  # Restaura o volume ao valor fixo
	_update_sliders()
	MusicController.play_SfxBtnConfirm()

func _update_sliders():
	# Obtém todos os filhos do VBox onde os sliders estão
	var sliders = Global.acha_filhos("HSlider", [], $lados/ScrolTab/TabContainer/VBoxSom)
	for slider in sliders:
		if slider is SOM:  # Verifica se o filho é da classe SOM
			slider._update_slider()  # Chama a função para atualizar o slider
