extends Button

@onready var backgroundSprite : Sprite2D = $background
@onready var container : CenterContainer = $CenterContainer
@onready var inventory = preload("res://inventory/PlayerInventory2.tres")

var itemStackGui : ItemStackGui
var index : int

func takeItem() -> ItemStackGui:
	var item = itemStackGui	
	inventory.removeSlot(itemStackGui.inventorySlot)
	return item

func clear() -> void:
	if itemStackGui:
		container.remove_child(itemStackGui)
		itemStackGui = null
	backgroundSprite.frame = 1

func isEmpty() -> bool:
	return ! itemStackGui

func insert(isg : ItemStackGui) -> void:
	itemStackGui = isg
	backgroundSprite.frame = 0
	container.add_child(itemStackGui)
	
	if ! itemStackGui.inventorySlot or inventory.slots[index] == itemStackGui.inventorySlot:
		return
	inventory.insertSlot(index, itemStackGui.inventorySlot)
