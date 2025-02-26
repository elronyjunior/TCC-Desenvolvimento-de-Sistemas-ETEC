class_name SOM extends HSlider

@export
var bus_name: String
var bus_index: int

func _ready() -> void:
	# Obtém o índice do barramento de áudio com base no nome
	bus_index = AudioServer.get_bus_index(bus_name)
	# Conecta o sinal de alteração de valor do slider ao método personalizado
	value_changed.connect(_on_value_changed)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_value_changed(value: float) -> void:
	# Define o volume do barramento de áudio em decibéis
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _update_slider():
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
