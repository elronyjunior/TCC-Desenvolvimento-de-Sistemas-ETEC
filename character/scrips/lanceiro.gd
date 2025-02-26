class_name Lanceiro extends CharacterBody2D

signal healthChanged
signal manaChanged

var _state_machine
var is_dead: bool = false
var _is_attacking: bool = false
var isHurt : bool = false  # Variável para imunidade temporária ao dano

var _direction: Vector2 = Vector2(
	Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down")
)

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _friction: float = 0.2
@export var _acceleration: float = 0.2
@export var _animation_tree: AnimationTree = null
@export var knockbackPower: int = 200
@export var inventory : Inventory
@export_category("Objects")
@onready var _attack_timer = $attackTimer
@onready var ice_timer = $ice_timer
@onready var hurtTimer = $hurtTimer
@onready var healthbar = $CanvasLayer/HealthBar
@onready var manabar = $CanvasLayer/ManaBar
@onready var effects = $Effects
@onready var hurtBox = $HurtBox
@onready var marker_2d = $Marker2D
@export var status: Status = Status.new()  # Cria uma nova instância de Status
@export var slime: Slime = Slime.new()
@onready var attack_sfx : AudioStreamPlayer = $attack_sfx
@onready var coletarItems_sfx : AudioStreamPlayer = $coletarItems_sfx
@onready var dano_sfx : AudioStreamPlayer = $dano_sfx
@onready var morrer_sfx : AudioStreamPlayer = $morrer_sfx
@onready var usarPocao_sfx : AudioStreamPlayer = $usarPocao_sfx

var dir: Vector2 = Vector2(1, 1)

# Direção de ataque travada
var attack_dir: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	manaChanged.emit(Global.mana)
	# Atualiza a barra de mana
	if is_instance_valid(manabar):
		# Atualiza o valor máximo da barra de mana
		manabar.update_max_mana(Global.maxMana)
		# Ajusta a mana global, garantindo que esteja dentro dos limites
		Global.mana = clamp( Global.mana, 0, Global.maxMana)
		# Atualiza a barra de mana e barra de esgotamento
		manabar._set_mana(Global.mana)
		
	healthChanged.emit(Global.health)
	# Atualiza a barra de vida
	if is_instance_valid(healthbar):
		# Atualiza o valor máximo da barra de vida
		healthbar.update_max_health(Global.maxHealth)
		# Ajusta a saúde global, garantindo que esteja dentro dos limites
		Global.health = clamp( Global.health, 0, Global.maxHealth)
		# Atualiza a barra de saúde e barra de dano
		healthbar._set_health(Global.health)

	if is_dead:
		return
	
	direcao()
	_move()
	_attack()
	_animate()
	move_and_slide()
	calculate_vitalidade()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "HitBox":
				hurtByEnemy(area)

func _ready() -> void:
	inventory.use_item.connect(use_item)
	healthbar.init_health(Global.health, Global.maxHealth)
	_animation_tree = $AnimationTree
	_state_machine = _animation_tree.get("parameters/playback")
	effects.play("RESET")
	Menu()

func knockback(enemyVelocity: Vector2) -> void:
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func hurtByEnemy(area) -> void:
	knockback(area.get_parent().velocity)
	take_damage()
	isHurt = true  # Jogador fica imune ao dano temporariamente
	
	effects.play("HurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

# Função para causar dano ao jogador
func take_damage() -> void:
	var reduced_damage = calculate_defense_reduction()
	Global.health -= reduced_damage
	print("Dano recebido: ", reduced_damage, ", Vida restante: ", Global.health)
	if Global.health <= 0:
		die()
	else:
		dano_sfx.play()
	healthChanged.emit(Global.health)
	# Atualiza a barra de vida
	if is_instance_valid(healthbar):
		# Atualiza o valor máximo da barra de vida
		healthbar.update_max_health(Global.maxHealth)
		# Garante que o valor de saúde está dentro dos limites
		Global.health = clamp( Global.health, 0, Global.maxHealth)
		# Define o novo valor de saúde na barra
		healthbar._set_health(Global.health)

# Função para controlar a direção do jogador
func direcao() -> void:
	if !_is_attacking:  # Atualiza a direção apenas se não estiver atacando
		_direction = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)
		if _direction != Vector2.ZERO:
			dir = _direction

func _move() -> void:
	if _is_attacking:  # Impede movimento enquanto ataca
		velocity = Vector2.ZERO
		return

	if _direction != Vector2.ZERO:
		_animation_tree["parameters/attack/blend_position"] = _direction
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction

		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return

	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
	velocity = _direction.normalized() * _move_speed

func _attack() -> void:
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		_is_attacking = true
		attack_dir = dir  # Bloqueia a direção de ataque
		_state_machine.travel("attack")
		attack_sfx.play()
		_attack_timer.start()

func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
		return

	if velocity.length() > 1:
		_state_machine.travel("walk")
		return

	_state_machine.travel("idle")

func _on_attack_timer_timeout() -> void:
	_is_attacking = false

func _on_attack_area_body_entered(_body: Node) -> void:
	if _body.is_in_group("inimigo"):
		_body.update_health()

func _on_ice_timer_timeout() -> void:
	Global.ice_coldown = false
func change_scene(scene_path: String) -> void:
	Global.set_last_scene(scene_path)  # Salva a cena atual no singleton Global
	print(scene_path)
	get_tree().change_scene_to_file("res://levels/scenes/dungeon_level.tscn")  # Troca para a nova cena


func die() -> void:
	is_dead = true
	_state_machine.travel("death")
	morrer_sfx.play()
	await get_tree().create_timer(1.0).timeout
	
	# Salva o caminho da cena atual
	var current_scene = get_tree().current_scene
	print(current_scene)
	if current_scene:
		Global.set_last_scene(current_scene.scene_file_path)
	else:
		print("Erro: Não foi possível salvar a cena atual.")
	# Troca para a tela de Game Over
	GameOver()
	# Verifica se há uma cena anterior ou usa um caminho padrão
	var scene_path = Global.get_last_scene() if Global.get_last_scene() != "" else "res://levels/scenes/test_level.tscn"
	# Usa o método personalizado para trocar a cena
	#change_scene(scene_path)

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
		coletarItems_sfx.play()

func _on_hurt_box_area_exited(_area: Area2D) -> void: pass

func increase_mana(amount: int) -> void:
	Global.mana += amount
	Global.mana = min(Global.maxHealth + (StatusPlayer.Inteligencia * 1.5), Global.mana)
	manaChanged.emit(Global.mana)
	# Atualiza a barra de mana
	if is_instance_valid(manabar):
		# Atualiza o valor máximo da barra de mana
		manabar.update_max_mana(Global.maxMana)
		# Ajusta a mana global, garantindo que esteja dentro dos limites
		Global.mana = clamp( Global.mana, 0, Global.maxMana)
		# Atualiza a barra de mana e barra de esgotamento
		manabar._set_mana(Global.mana)

func increase_health(amount: int) -> void:
	Global.health += amount
	Global.health = min(Global.maxHealth + (StatusPlayer.Vitalidade * 1.5), Global.health)
	healthChanged.emit(Global.health)
	# Atualiza a barra de vida
	if is_instance_valid(healthbar):
		# Atualiza o valor máximo da barra de vida
		healthbar.update_max_health(Global.maxHealth)
		# Ajusta a saúde global, garantindo que esteja dentro dos limites
		Global.health = clamp( Global.health, 0, Global.maxHealth)
		# Atualiza a barra de saúde e barra de dano
		healthbar._set_health(Global.health)

		
func use_item(item: InventoryItem) -> void:
	if item is HealthItem and Global.health < Global.maxHealth + (StatusPlayer.Vitalidade * 1.5):
		increase_health(item.health_increase)
		item.use3(self)
		print("item usado", " Vida atual: ", Global.health)
		usarPocao_sfx.play()

	if item is ManaItem and Global.mana < Global.maxMana + (StatusPlayer.Inteligencia * 1.5): 
		increase_mana(item.mana_increase)
		item.use3(self)
		print("item usado", " Mana atual: ", Global.mana)
		usarPocao_sfx.play()


func calculate_defense_reduction() -> float:
	# Reduz o dano recebido baseado na defesa
	var reduction = StatusPlayer.Defesa * 0.5
	return max(0, slime.dano_slime - reduction)

func calculate_mana() -> float:
	# Cada ponto de inteligência aumenta a mana total
	return status.Inteligencia * 1.5

func calculate_vitalidade() -> float:
	# Cada ponto de inteligência aumenta a mana total
	return Global.maxHealth + (status.Vitalidade * 1.5)

func Menu():
	var menu:=preload("res://Player/menu.HUD/menu/menu.tscn").instantiate()
	get_parent().add_child.call_deferred(menu)

func GameOver() -> void:
		queue_free()
		get_tree().change_scene_to_file('res://UI/scenes/game_over.tscn')
