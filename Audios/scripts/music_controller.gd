extends Node2D

@onready var bgMusic_menu = $bgMusic_menu
@onready var bgSfx_menuButton = $bgSfx_menuButton
@onready var bgSfx_menuCancel = $bgSfx_menuCancel
@onready var bgSfx_menuConfirm = $bgSfx_menuConfirm


func play_music():
	bgMusic_menu.play()

func stop_music():
	bgMusic_menu.stop()

func play_SfxBtnMenu():
	bgSfx_menuButton.play()
	
func play_SfxBtnConfirm():
	bgSfx_menuConfirm.play()
	
func play_SfxBtnCancel():
	bgSfx_menuCancel.play()
