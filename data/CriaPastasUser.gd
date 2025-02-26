extends Node
func _ready() -> void:
	cria_data_basic()
func cria_data_basic():
	if(!DirAccess.dir_exists_absolute("user://data")):
		DirAccess.make_dir_absolute(str("user://data"))
	if (DirAccess.dir_exists_absolute(str("user://data","/",Global.email))):
		var folders_a_verificar=["img_saves"]
		for folders in folders_a_verificar:
			if(!DirAccess.dir_exists_absolute(str("user://data","/",Global.email,folders))):
				DirAccess.make_dir_absolute(str("user://data","/",Global.email,"/",folders))
	else:
		DirAccess.make_dir_absolute(str("user://data","/",Global.email))
		cria_data_basic()
		
