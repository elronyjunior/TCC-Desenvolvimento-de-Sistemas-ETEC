extends Resource
class_name  ConfigData
var save_path=str("res://data/config_data.tres")
@export var key_binds={"0": "Q","1": "E","2": "R","attack": "J","baixo": "S","cima": "W","direita": "D","esquerda": "A"}
# Called when the node enters the scene tree for the first time.

func save_game():
	ResourceSaver.save(self,save_path)
func load_game():
	var saved_data = ResourceLoader.load(save_path)
	var loaded_data = saved_data as ConfigData
	return loaded_data
