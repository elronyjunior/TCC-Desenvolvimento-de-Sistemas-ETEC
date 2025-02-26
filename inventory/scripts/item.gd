# Estrutura básica de um item
class_name Item

# Propriedades do item
@export var name: String = "Item"
@export var icon: Texture # Ícone do item
@export var description: String = "Descrição do item"

# Construtor
func _init(name: String, icon: Texture, description: String = "Descrição do item"):
	self.name = name
	self.icon = icon
	self.description = description
