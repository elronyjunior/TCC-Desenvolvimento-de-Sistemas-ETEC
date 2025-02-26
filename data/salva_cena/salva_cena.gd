class_name Salva_cena extends Node

func load_node(path:NodePath):
	get_tree().change_scene_to_file(path)

func save_scene(node:Node2D, path: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	# Salva o recurso (packed_scene) no caminho especificado
	var err = ResourceSaver.save(packed_scene, path)
	if err != OK:
		print("Erro ao salvar a cena:", err)
	else:
		print("Cena salva com sucesso em:", path)
