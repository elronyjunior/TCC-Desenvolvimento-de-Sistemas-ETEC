extends Node2D

@onready var enemy_scene = preload("res://character/scenes/slime.tscn")
@onready var mob_scene = preload("res://character/scenes/sheep.tscn")

var slime_count = 0
var sheep_count = 0
var max_slimes = 20
var max_sheep = 40

@onready var slime_timer = Timer.new()
@onready var sheep_timer = Timer.new()

# Tamanho do mundo ou área onde os mobs podem spawnar
var spawn_area_min = Vector2(0, 0)
var spawn_area_max = Vector2(300, 240)

func _ready():
	print(get_node("../Enemy"))
	# Configura o Timer e adiciona à cena
	slime_timer.wait_time = 3
	slime_timer.one_shot = true
	add_child(slime_timer)
	
	sheep_timer.wait_time = 3
	sheep_timer.one_shot = true
	add_child(sheep_timer)

	# Começa o spawn com as funções async
	spawn_slimes()
	spawn_sheep()

# Função para verificar se há colisões na posição
func is_valid_spawn_position(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	# Criação de uma forma simples para a checagem (círculo, ajustável)
	var shape = CircleShape2D.new()
	shape.radius = 16  # Ajuste o tamanho conforme necessário

	# Configuração do teste de colisão
	var transform = Transform2D(0, position)  # Forma posicionada no mundo
	var query_params = PhysicsShapeQueryParameters2D.new()
	query_params.shape = shape
	query_params.transform = transform
	query_params.collision_mask = 1  # Ajuste a máscara de colisão, se necessário

	# Verifica se a posição está livre
	var result = space_state.intersect_shape(query_params, 1)  # Limita a 1 colisão detectada
	return result.is_empty()  # Se não houver colisões, a posição é válida


# Função para encontrar uma posição válida
func get_valid_spawn_position() -> Vector2:
	var tries = 10  # Número máximo de tentativas
	while tries > 0:
		var position = Vector2(
			randf_range(spawn_area_min.x, spawn_area_max.x),
			randf_range(spawn_area_min.y, spawn_area_max.y)
		)
		if is_valid_spawn_position(position):
			return position
		tries -= 1
	# Retorna uma posição padrão caso todas as tentativas falhem
	return spawn_area_min


# Função para spawn assíncrono de slimes
func spawn_slimes():
	while slime_count < max_slimes:
		slime_timer.start()
		await slime_timer.timeout
		var enemy = enemy_scene.instantiate()
		enemy.position = get_valid_spawn_position()  # Posição válida
		get_node("../Enemy").add_child(enemy)
		slime_count += 1
		enemy.connect("killed", _on_slime_killed)

# Função para spawn assíncrono de ovelhas
func spawn_sheep():
	while sheep_count < max_sheep:
		sheep_timer.start()
		await sheep_timer.timeout
		var mob = mob_scene.instantiate()
		mob.position = get_valid_spawn_position()  # Posição válida
		get_node("../Enemy").add_child(mob)
		sheep_count += 1
		mob.connect("killed", _on_sheep_killed)

# Função chamada quando um slime é morto
func _on_slime_killed() -> void:
	slime_count -= 1
	if slime_count < max_slimes:
		spawn_slimes()

# Função chamada quando uma ovelha é morta
func _on_sheep_killed() -> void:
	sheep_count -= 1
	if sheep_count < max_sheep:
		spawn_sheep()
