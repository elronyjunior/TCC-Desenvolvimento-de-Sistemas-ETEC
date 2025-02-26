class_name Collectable extends Area2D

@onready var sprite = $Sprite2D
@onready var coletarItems_sfx : AudioStreamPlayer = $coletarItems_sfx
@export var itemRes : InventoryItem

func _physics_process(_delta: float) -> void:
	sprite.visible = true
	

func collect(inventory: Inventory):
	if inventory.insert(itemRes):
		if itemRes.name == "ManaPot":  # Verifica se é o manapot
			sprite.scale = Vector2(0.1, 0.1)  # Ajuste apenas para o manapot
		else:
			sprite.scale = Vector2(2, 2)  # Ajuste apenas para o manapot
		
		queue_free()
	else:
		# Adicionar uma animação ou indicador visual para o jogador
		pass
