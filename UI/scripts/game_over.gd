extends CanvasLayer

func _ready() -> void:
	pass # Replace with function body.
func _process(_delta: float) -> void:
	pass

func _on_btn_restart_pressed() -> void:
	var last_scene = Global.get_last_scene()
	if last_scene != "":
		get_tree().change_scene_to_file(last_scene)
	else:
		print("Erro: Nenhuma cena anterior foi salva.")

func _on_btn_config_pressed() -> void:
	pass # Replace with function body.


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
	MusicController.play_SfxBtnCancel()
