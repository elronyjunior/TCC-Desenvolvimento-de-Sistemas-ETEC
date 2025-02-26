extends Panel

class_name ItemStackGui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label
var inventorySlot: InventorySlot

func update():
	# Verifica se o slot é válido e contém um item
	if not inventorySlot or not inventorySlot.item:
		itemSprite.visible = false  # Esconde o sprite se o slot estiver vazio
		amountLabel.visible = false
		return
	else:
		# Exibe o item e define o ícone
		itemSprite.visible = true
		itemSprite.texture = inventorySlot.item.texture

		# Ajusta a escala apenas para o manapot
		if inventorySlot.item.name == "ManaPot":  # Substitua "ManaPot" pelo nome correto
			itemSprite.scale = Vector2(0.1, 0.1)  # Ajuste a escala para o manapot
		else:
			itemSprite.scale = Vector2(2, 2)  # Escala padrão para outros itens

	# Atualiza a quantidade exibida na label
	if inventorySlot.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)
	else:
		amountLabel.visible = false
