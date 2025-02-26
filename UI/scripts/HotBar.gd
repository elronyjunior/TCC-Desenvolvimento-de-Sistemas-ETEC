extends Panel

@onready var inventory : Inventory = preload("res://inventory/PlayerInventory2.tres")
@onready var slots : Array = Global.acha_filhos("Button", [], $Container)
@onready var selector = $Container/Selector

var currently_selected : int = 0

func _ready() -> void:
	update()
	inventory.updated.connect(update)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot : InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)

#func update1() -> void:
	#for i in range(slots.size()):
		#var inventory_slot : InventorySlot = inventory.slots[i]
		## Verifica se o slot possui o método 'update_to_slot'
		#if slots[i].has_method("update_to_slot"):
			#slots[i].update_to_slot(inventory_slot)
		#else:
			#print("Slot no índice ", i, " não possui o método 'update_to_slot'.")


func move_selector():
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event) -> void:
	if event.is_action_pressed("use_item"):
		var selected_item = inventory.get_item_at_index(currently_selected)
		
		# Verifica se o item selecionado é uma poção e se a vida do jogador está máxima
		if selected_item is HealthItem:
			if Global.health >= Global.maxHealth:
				print("Vida já está no máximo! Não é possível usar a poção.")
			else:
				inventory.use_item_at_index(currently_selected)
				# Verifica se o item selecionado é uma poção e se a vida do jogador está máxima
		if selected_item is ManaItem:
			if Global.mana >= Global.maxMana:
				print("Mana já está no máximo! Não é possível usar a poção.")
			else:
				inventory.use_item_at_index(currently_selected)
	if event.is_action_pressed("move_selector"):
		move_selector()
