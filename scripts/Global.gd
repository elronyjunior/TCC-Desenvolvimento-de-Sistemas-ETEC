extends Node
var tela:Viewport
var FPS:bool=true
var coldown_0:bool=false
var coldown_1:bool=false
var coldown_2:bool=false
var navigation:bool=false
var time_await={0:0,1:0,2:0}
var slot:int
var email:String="admin"
var label=Label.new()
var time: =2
var ice_coldown:bool=false
var has_stick = true
var inventory = []
var max_inventory_size = 4

var default_volumes: Array = []

var maxHealth : float = 10
var health : float = maxHealth # Inicia com 10 de vida

var maxMana : float = 10
var mana : float = maxMana

var salva_cena = Salva_cena.new()
var currently_scene : Node

var last_scene: String = "" # Armazena o caminho da última cena carregada
func set_last_scene(scene_path: String) -> void:
	if scene_path != "":
		last_scene = scene_path
	else:
		print("Aviso: Caminho da cena vazio não foi salvo.")

func get_last_scene() -> String:
	return last_scene


var playerDir
var player: Node2D

func instance_node (node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance


func add_item_to_inventory (item):
	for i in range(min (inventory.size(), max_inventory_size)):
		if inventory[i] == null:
			inventory[i]= item
			return
	if inventory.size() < max_inventory_size:
		inventory.append(item)
	else:
		print("Inventory is full")
func get_inventory():
	return inventory

func _ready():
	DisplayServer.window_set_min_size(Vector2(800, 600))
func _notification(what):
	if(what == 1006):
		"""CASO FECHE EM ALGUM LUGAR QUE NÃO SEJA A FASE QUEBRA"""
		currently_scene=get_node("/root").get_child(9)
		await printscreen()
		await salva_cena.save_scene(currently_scene,str("user://data/",email,"/save_game_",slot,".tscn"))
		#await salva_cena.save_scene(currently_scene,"user://data/"+email+"/gamesave"+slot+".tscn")

func printscreen():
	if(slot > 0):
		await RenderingServer.frame_post_draw
		var viewport = get_viewport()
		var img = viewport.get_texture().get_image()
		img.save_png(str("res://data/img_save/",slot,".png"))
func _physics_process(_delta):
	pass

func load_game(save_path : String):
	var saved_data = ResourceLoader.load(save_path)
	var loaded_data = saved_data as PlayerData
	return loaded_data

func proporcional(tamanho_text : int, maximus : int) -> float :
	var tam_abertura = Vector2(1152, 648)
	var resolucao = get_viewport().size
	var text_size = tamanho_text
	var area_abertura = tam_abertura[0]*tam_abertura[1]
	var area_resolucao = resolucao[0]*resolucao[1]
	var diferenca = area_resolucao - area_abertura
	var percentual:int = (diferenca / area_abertura) * 100
	var resultado=(((float(text_size)/100)*percentual)+(text_size))
	if(resultado>=maximus):
		return maximus
	return resultado


func acha_filhos(tipe:String,excecoes:Array=[],node_pai:Node=get_node("/root").get_child(6),array_filhos:Array=[]):
	var banido:bool=false
	for filho in node_pai.get_children():
		if(filho.get_child_count()>0):
			acha_filhos(tipe,excecoes,filho,array_filhos)
		if excecoes != []:
			for excecao in excecoes:
				if filho.name==str(excecao):
					banido=true
		if filho.is_class(tipe) && !banido:
			array_filhos.append(filho)
		banido=false
	return array_filhos
#slot/tiro/tempo/dano
var habilidades={0:["ice",3,10],1:["fire",2,5],2:["ice",2,5]}
