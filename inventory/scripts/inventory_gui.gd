extends Control

signal opened
signal closed

@onready var inventory : Inventory = preload("res://inventory/PlayerInventory2.tres")
@onready var ItemStackGuiClass = preload("res://UI/scenes/ItemStackGui.tscn")
@onready var hotbar_slots : Array = $NinePatchRect/HBoxContainer.get_children()
@onready var slots : Array = hotbar_slots + $NinePatchRect/GridContainer.get_children()


var isOpen : bool = false
var itemInHand : ItemStackGui
var oldIndex : int = -1
var locked : bool = false

func _ready() -> void:
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		if not inventorySlot.item:
			slots[i].clear()
			continue

		# Acesse corretamente itemStackGui no slot (Button)
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if not itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)

		# Ajusta a escala do itemSprite condicionalmente
		if inventorySlot.item.name == "ManaPot":  # Substitua "ManaPot" pelo nome do manapot
			itemStackGui.itemSprite.scale = Vector2(0.1, 0.1)  # Escala menor para o manapot
		else:
			itemStackGui.itemSprite.scale = Vector2(2, 2)  # Escala padrão para outros itens

		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

func onSlotClicked(slot):
	if locked: return
	
	if slot.isEmpty():
		if ! itemInHand: return
		
		insertItemInSlot(slot)
		return
		
	if ! itemInHand:
		takeItemFromSlot(slot)
		return
		
	if slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
		stackItems(slot)
		return
	swapItems(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
	oldIndex = slot.index

func insertItemInSlot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	oldIndex = -1

func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

#func distribute_to_next_slot():
	#for slot in slots:
		#var inventorySlot = slot.itemStackGui.inventorySlot
		#if inventorySlot.amount < inventorySlot.maxAmountPrStack and inventorySlot.item == itemInHand.inventorySlot.item:
			#stackItems(slot)
			#return
	#
	## Caso todos os slots estejam cheios, cria um novo se possível
	#for slot in slots:
		#if slot.isEmpty():
			#insertItemInSlot(slot)
			#return

func updateItemInHand():
	if ! itemInHand:
		return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func putItemBack():
	locked = true
	if oldIndex < 0:
		var emptySlots = slots.filter(func (s): return s.isEmpty())
		if emptySlots.is_empty(): return
		
		oldIndex = emptySlots[0].index
	var targetSlot = slots[oldIndex]
	
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size / 2
	tween.tween_property(itemInHand, "global_position", targetPosition, 0.2)
	
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false

func stackItems(slot):
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountPrStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	
	# Verifica se o slot já está cheio
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
	
	# Caso o total seja menor ou igual ao máximo, soma e remove o item da mão
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
	else:
		# Caso o total exceda o máximo, ajusta as quantidades
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount

	# Atualiza a interface gráfica
	slotItem.update()
	if itemInHand: itemInHand.update()

func _input(_event):
	if itemInHand && !locked && Input.is_action_just_pressed("rightClick"):
		putItemBack()
	updateItemInHand()
