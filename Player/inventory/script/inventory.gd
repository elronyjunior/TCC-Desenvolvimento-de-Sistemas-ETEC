extends CanvasLayer
@export var inventory_grid:GridContainer = null
@export var equip_grid:GridContainer = null
@export var path_inventory_JSON:String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_index()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_slot():
	for i in range(32):
		var slot = load("res://Player/inventory/slot/inventory_slot.tscn").instantiate()
		slot.name=str(i)
		inventory_grid.add_child(slot)

func read_inventory():
	var data_slot:Dictionary
	var file=FileAccess.open(path_inventory_JSON,FileAccess.READ)
	data_slot=JSON.parse_string(file.get_as_text())
	file.close()
	return data_slot

func add_index():
	var tamanho_dicionario=read_inventory().size()
	var dicionario_slot=read_inventory()
	dicionario_slot[str(tamanho_dicionario)]={}
	"""passar as propriedades dos itens nas chaves"""
