class_name Healthbar extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health) -> void:
	var prev_health = health
	health = clamp(new_health, 0, max_value)  # Garante que saúde está dentro dos limites
	value = health  # Atualiza a barra principal imediatamente
	# Se a saúde caiu, inicia o temporizador para reduzir a barra de dano
	if health < prev_health:
		timer.start()
	elif health > prev_health:
		# Se a saúde aumentou (cura), ajusta a barra de dano imediatamente
		damage_bar.value = health

func init_health(_health, _max_health) -> void:
	health = _health
	max_value = _max_health
	value = health
	damage_bar.max_value = _max_health
	damage_bar.value = health

func update_max_health(new_max_health) -> void:
	# Atualiza apenas o valor máximo
	max_value = new_max_health
	damage_bar.max_value = new_max_health
	
	# Garante que a saúde atual e a barra de dano estejam dentro dos limites
	health = clamp(health, 0, max_value)
	value = health
	damage_bar.value = max(damage_bar.value, health)  # Garante que a barra de dano não esteja abaixo da saúde atual

func _on_timer_timeout() -> void:
	damage_bar.value = health
