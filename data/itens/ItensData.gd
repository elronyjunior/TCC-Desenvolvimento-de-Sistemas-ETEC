extends Node
class_name ItensJSON
var DCitens:Dictionary
var path:String="res://data/itens/data_itens.json"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func get_data(indice,campo=null):
	var dicionario:Dictionary=itens_json()
	if (campo !=null):
		return dicionario[str(indice)][campo]
	else:
		return dicionario[str(indice)]
	
func itens_json():
	var data_itens:Dictionary
	var file=FileAccess.open(path,FileAccess.READ)
	data_itens=JSON.parse_string(file.get_as_text())
	file.close()
	return data_itens
