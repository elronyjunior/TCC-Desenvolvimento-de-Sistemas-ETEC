extends Node2D

func _ready() -> void:
	MusicController.stop_music()  # Para a música (caso esteja tocando)
	

func _on_inventory_gui_closed() -> void:#sinal do inventory gui não está conectado
	get_tree().paused = false

func _on_inventory_gui_opened() -> void:#sinal do inventory gui não está conectado
	get_tree().paused = true
