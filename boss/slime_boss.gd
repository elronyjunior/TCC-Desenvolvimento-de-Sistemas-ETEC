class_name Slime_boss extends CharacterBody2D



signal killed  # Define o sinal
signal enemy_died

var is_dead: bool = false
var _player_ref = null  # Referência ao jogador
var maxHealth: float = 10
var health: float = maxHealth  # Vidas do slime
var dano_slime: float = 20


@export_category("Itens Drops")
@export var drops : Array [DropData]

@onready var main = get_node("/root/TestLevel")
@onready var bg_sfxMorte = $bg_sfxMorte
@onready var bg_sfxDano = $bg_sfxDano
@export_category("Objects")
@export var _texture: Sprite2D = null
@export var _animation: AnimationPlayer = null
@onready var healthbar = $HealthBar
@onready var hurtTimer = $hurtTimer
@onready var effects = $Effects
@onready var randomMoveTimer = $RandomMoveTimer  # Timer para controlar o movimento aleatório
@onready var DetectorWallRight = $DetectorWallRight # RayCast2D para colisão à direita
@onready var DetectorWallLeft = $DetectorWallLeft   # RayCast2D para colisão à esquerda
@onready var DetectorWallBottom = $DetectorWallBottom # RayCast2D para colisão embaixo
@onready var DetectorWallTop = $DetectorWallTop      # RayCast2D para colisão em cima
@export var status: Status = Status.new()  # Cria uma nova instância de Status

var random_direction = Vector2.ZERO
var random_speed = 50

func _ready() -> void:
	healthbar.init_health(health, maxHealth)
	healthbar.visible = false  # A barra de vida começa invisível
	effects.play("RESET")
	
	# Ativa todos os RayCasts para detecção de colisão
	DetectorWallRight.enabled = true
	DetectorWallLeft.enabled = true
	DetectorWallBottom.enabled = true
	DetectorWallTop.enabled = true
	
	# Garante que o Timer esteja na árvore antes de chamá-lo
	if not randomMoveTimer.is_inside_tree():
		add_child(randomMoveTimer)
		
	randomMoveTimer.start()  # Agora pode começar, pois foi adicionado à árvore
	_on_RandomMoveTimer_timeout()  # Inicia a direção inicial aleatória

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	if(health<maxHealth/4):
		random_speed = 100
	_animate()

	if _player_ref != null:
		# Slime persegue o player se ele estiver na área de detecção
		var direction = global_position.direction_to(_player_ref.global_position)
		velocity = direction * random_speed
	else:
		# Movimento aleatório quando o player não está na área de detecção
		velocity = random_direction * random_speed

		# Verifica colisões com paredes e ajusta a direção
		if DetectorWallRight.is_colliding():
			var collider = DetectorWallRight.get_collider()
			if collider and not collider.is_in_group("player"):
				random_direction.x = -abs(random_direction.x)  # Muda direção para a esquerda

		elif DetectorWallLeft.is_colliding():
			var collider = DetectorWallLeft.get_collider()
			if collider and not collider.is_in_group("player"):
				random_direction.x = abs(random_direction.x)  # Muda direção para a direita

		if DetectorWallBottom.is_colliding():
			var collider = DetectorWallBottom.get_collider()
			if collider and not collider.is_in_group("player"):
				random_direction.y = -abs(random_direction.y)  # Muda direção para cima

		elif DetectorWallTop.is_colliding():
			var collider = DetectorWallTop.get_collider()
			if collider and not collider.is_in_group("player"):
				random_direction.y = abs(random_direction.y)  # Muda direção para baixo

	
	move_and_slide()

# Função para controlar a animação com base na direção do movimento
func _animate() -> void:
	# Controla a direção do sprite (flip horizontal)
	if velocity.x > 0:
		_texture.flip_h = false
	elif velocity.x < 0:
		_texture.flip_h = true
	
	# Toca a animação de caminhar ou idle dependendo da velocidade
	if velocity != Vector2.ZERO:
		_animation.play("walk")
	else:
		_animation.play("idle")

# Função chamada pelo Timer para gerar movimento aleatório
func _on_RandomMoveTimer_timeout() -> void:
	if _player_ref == null:  # Só muda o movimento se o player não estiver na área
		random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Função chamada quando o slime perde vida
func update_health() -> void:
	var actual_damage = StatusPlayer.Forca * 1.5  # Multiplicador de dificuldade
	health -= actual_damage
	bg_sfxDano.play()
	if is_instance_valid(healthbar):
		healthbar.health = health

	if health <= 0:
		is_dead = true
		_animation.play("death")
		bg_sfxMorte.play()
		emit_signal("killed")
		emit_signal("enemy_died")
		if is_instance_valid(healthbar):
			healthbar.visible = false
	else:
		if is_instance_valid(healthbar):
			healthbar.visible = true

	effects.play("HurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	emit_signal("enemy_died")

func _on_animation_finished(_anim_name: String) -> void:
	if _anim_name == "death":
		get_node("/root/LevelManager").gain_exp(1000)
		queue_free()
		drop_items()

func drop_items() -> void:
	var drop_count = randi_range(0, 3)  # Quantidade aleatória de itens, de 0 a 3

	for i in drop_count:
		for drop_data in drops:
			var count = drop_data.get_drop_count()
			for j in count:
				if drop_data.item_scene and drop_data.item_scene is PackedScene:
					var item = drop_data.item_scene.instantiate()
					item.global_position = global_position + Vector2(randf() * 16, randf() * 16)

					# Configura o tamanho do sprite do item (reduzido)
					if item.has_node("Sprite2D"):
						var sprite = item.get_node("Sprite2D")
						sprite.scale = Vector2(0.05, 0.05)
					
					item.visible = true
					item.z_index = 10
					main.call_deferred("add_child", item)
					item.add_to_group("items")
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
	var tween = item.create_tween()
	
	# Configura a escala inicial pequena
	item.scale = Vector2(0.05, 0.05)
	
	# Animação de expansão
	tween.tween_property(item, "scale", Vector2(1, 1), 0.3)

	# Animação de movimento
	var final_position_y = item.position.y - 10
	tween.tween_property(item, "position:y", final_position_y, 0.3)
