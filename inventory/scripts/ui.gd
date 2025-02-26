extends CanvasLayer

@onready var inventory = $InventoryGui

func _ready() -> void:
	inventory.close()
# Called when the node enters the scene tree for the first time.
func _input(event) -> void:
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
	if event.is_action_pressed("character_sheet"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://UI/scenes/character_sheet.tscn").instantiate()
			add_child(character_sheet)
		else:
			get_node("CharacterSheet").queue_free()
