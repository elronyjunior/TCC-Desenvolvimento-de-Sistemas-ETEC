extends Button

@onready var background_Sprite : Sprite2D = $background
@onready var item_stack_gui : ItemStackGui = $CenterContainer/Panel
func _physics_process(_delta: float) -> void:
	# Define a escala do item_stack_gui para um valor menor
	item_stack_gui.scale = Vector2(0.5, 0.5)  # Ajuste o valor conforme necessário
	
# Atualiza o item_stack_gui para corresponder ao slot
func update_to_slot(slot : InventorySlot) -> void:
	if slot.item:
		item_stack_gui.inventorySlot = slot  # Primeiro, atualize o slot
		item_stack_gui.update()  # Em seguida, atualize a GUI do item
		item_stack_gui.visible = true  # Torna visível se o slot tiver um item
		background_Sprite.frame = 0
	else:
		item_stack_gui.visible = false  # Oculta o item_stack_gui se não houver item
		background_Sprite.frame = 1
