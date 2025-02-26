extends Resource
class_name Screenshot
var save_path="res://prints/save_print.tres"
@export var screenshot_load:int

func save_print(N:int):
	screenshot_load=N
	ResourceSaver.save(self,save_path)
	
func load_print():
	var saved_print = ResourceLoader.load(save_path)
	var loaded_print_data = saved_print as Screenshot
	return loaded_print_data
