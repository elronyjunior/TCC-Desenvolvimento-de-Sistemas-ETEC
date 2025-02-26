class_name Sheep extends CharacterBody2D

var item_scene = preload("res://Collectables/scenes/lifepot.tscn")

signal killed  # Define o sinal

var is_dead: bool = false
var random_direction = Vector2.ZERO
var random_speed = 20
var _change_direction_timer: Timer
@export var _texture: Sprite2D = null
@export var _animation: AnimationPlayer = null

@export_category("Itens Drops")
@export var drops : Array [DropData]

@onready var sheepDie : AudioStreamPlayer = $sheepDie
@onready var main = get_node("/root/TestLevel")
@onready var randomMoveTimer = $RandomMoveTimer  # Timer para controlar o movimento aleatório
# RayCast2D para detectar colisões nas quatro direções
@onready var DetectorWallRight = $DetectorWallRight
@onready var DetectorWallLeft = $DetectorWallLeft
@onready var DetectorWallTop = $DetectorWallTop
@onready var DetectorWallBottom = $DetectorWallBottom

func _ready() -> void:
	# Ativa todos os RayCasts para detectar colisão
	DetectorWallRight.enabled = true
	DetectorWallLeft.enabled = true
	DetectorWallTop.enabled = true
	DetectorWallBottom.enabled = true
	
	# Inicializa o _texture e _animation corretamente
	_texture = $Texture
	_animation = $Animation  # Substitua pelo caminho correto na sua cena
	
		# Garante que o Timer esteja na árvore antes de chamá-lo
	if not randomMoveTimer.is_inside_tree():
		add_child(randomMoveTimer)
	randomMoveTimer.start()
	_on_RandomMoveTimer_timeout()  # Inicia a direção inicial aleatória

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	_animate()

# Movimento aleatório quando o player não está na área de detecção
	velocity = random_direction * random_speed

# Verifica colisões com paredes e com os grupos desejados (player, inimigo, safe_mob)
	if DetectorWallRight.is_colliding():
		random_direction.x = -abs(random_direction.x)  # Muda direção para a esquerda
	elif DetectorWallLeft.is_colliding():
		random_direction.x = abs(random_direction.x)  # Muda direção para a direita

	if DetectorWallBottom.is_colliding():
		random_direction.y = -abs(random_direction.y)  # Muda direção para cima
	elif DetectorWallTop.is_colliding():
		random_direction.y = abs(random_direction.y)  # Muda direção para baixo
	
	move_and_slide()

func _animate() -> void:
	if velocity.x > 0:
		_texture.flip_h = false
	elif velocity.x < 0:
		_texture.flip_h = true

	if _animation != null:
		if velocity != Vector2.ZERO:
			_animation.play("walk")
		else:
			_animation.play("idle")

# Define uma nova direção aleatória a cada timeout
func _on_RandomMoveTimer_timeout() -> void:
	random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Função chamada quando a ovelha perde vida
func update_health() -> void:
	sheepDie.play()
	is_dead = true
	_animation.play("death")
	emit_signal("killed")  # Emite o sinal de morte


func _on_animation_finished(_anim_name):
	queue_free()
	get_node("/root/LevelManager").gain_exp(500)
	drop_items()
	
func drop_items() -> void:
	var drop_count = randi_range(0, 3)  # Quantidade aleatória de itens, de 0 a 3

	for i in drop_count:
		for drop_data in drops:
			var count = drop_data.get_drop_count()
			for j in count:
				# Instancia o item a partir da cena carregada em item_scene
				if drop_data.item_scene and drop_data.item_scene is PackedScene:
					var item = drop_data.item_scene.instantiate()
					item.global_position = global_position + Vector2(randf() * 16, randf() * 16)

					# Configura a visibilidade e a animação de "drop" do item
					item.visible = true
					for child in item.get_children():
						if child is Sprite2D:
							child.modulate.a = 1  # Define a opacidade para 100% opaco
							child.visible = true

					item.z_index = 10  # Define um z_index alto para garantir visibilidade
					main.call_deferred("add_child", item)
					item.add_to_group("items")
					
					# Anima o item caindo
					_animate_drop(item)

func _get_random_drop() -> DropData:
	# Seleciona um DropData aleatório da lista `drops`, levando em conta a probabilidade
	var total_drops = []
	for drop in drops:
		var drop_count = drop.get_drop_count()
		for j in range(drop_count):
			total_drops.append(drop)

	if total_drops.size() > 0:
		return total_drops[randi() % total_drops.size()]
	return null

func _animate_drop(item: Node2D) -> void:
	# Cria a animação para o item
	var tween = item.create_tween()
	
	# Animação de escala de entrada (efeito de "pop")
	item.scale = Vector2(0.5, 0.5)
	tween.tween_property(item, "scale", Vector2(1, 1), 0.3)
	
	# Animação de movimento de entrada
	var final_position_y = item.position.y - 10
	tween.tween_property(item, "position:y", final_position_y, 0.3)
