class_name Inventory extends Resource

signal updated
signal use_item

@export var slots : Array[InventorySlot]

func insert(item: InventoryItem) -> bool:
	# Tenta encontrar um slot com o mesmo item que ainda não está cheio
	for slot in slots:
		if slot.item == item and slot.amount < slot.maxAmountPrStack:
			var available_space = slot.maxAmountPrStack - slot.amount
			slot.amount += min(available_space, 1)
			updated.emit()  # Emite o sinal para indicar que o inventário foi atualizado
			return true  # Item adicionado com sucesso

	# Se não encontrar um slot com o mesmo item ou se todos estiverem cheios,
	# tenta encontrar um slot vazio para adicionar o novo item
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount = 1
			updated.emit()
			return true  # Item adicionado com sucesso

	# Caso o inventário esteja cheio e o item não possa ser adicionado
	return false  # Indica que o item não pôde ser adicionado

func removeSlot(inventorySlot : InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	remove_at_index(index)

func remove_at_index(index) -> void:
	slots[index] = InventorySlot.new()
	updated.emit()

func insertSlot(index : int, inventorySlot : InventorySlot):
	slots[index] = inventorySlot
	updated.emit()

func use_item_at_index(index):
	if index < 0 || index >= slots.size() || !slots[index].item : return
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -= 1
		updated.emit()
		return
	remove_at_index(index)

func get_item_at_index(index: int) -> InventoryItem:
	if index >= 0 and index < slots.size():
		return slots[index].item
	return null
