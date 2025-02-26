extends Node

# Tamanho máximo do inventário
@export var maxSlots: int = 20

# Lista de itens no inventário
var items: Array

func _ready():
	items = []

# Adicionar um item ao inventário
func add_item(item: Item) -> bool:
	if items.size() < maxSlots:
		items.append(item)
		return true
	else:
		return false

# Remover um item do inventário (por índice)
func remove_item(items, index: int) -> bool:
	if index >= 0 and index < items.size():
		items.remove(index)
		return true
	else:
		return false

# Verificar se o inventário está cheio
func is_full() -> bool:
	return items.size() >= maxSlots

# Obter um item pelo índice
func get_item(index: int) -> Item:
	return items[index]

# Obter o número de itens no inventário
func get_item_count() -> int:
	return items.size()

# Limpar todos os itens do inventário
func clear_inventory():
	items.clear()
