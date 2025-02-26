class_name Manabar extends ProgressBar

@onready var timer = $Timer
@onready var depletion_bar = $depletionBar

var mana = 0 : set = _set_mana

func _set_mana(new_mana) -> void:
	var prev_mana = mana
	mana = clamp(new_mana, 0, max_value)  # Garante que saúde está dentro dos limites
	value = mana  # Atualiza a barra principal imediatamente
	# Se a saúde caiu, inicia o temporizador para reduzir a barra de dano
	if mana < prev_mana:
		timer.start()
	elif mana > prev_mana:
		# Se a saúde aumentou (cura), ajusta a barra de dano imediatamente
		depletion_bar.value = mana

func init_mana(_mana, _max_mana) -> void:
	mana = _mana
	max_value = _max_mana
	value = mana
	depletion_bar.max_value = _max_mana
	depletion_bar.value = mana

func update_max_mana(new_max_mana) -> void:
	# Atualiza apenas o valor máximo
	max_value = new_max_mana
	depletion_bar.max_value = new_max_mana
	
	# Garante que a saúde atual e a barra de dano estejam dentro dos limites
	mana = clamp(mana, 0, max_value)
	value = mana
	depletion_bar.value = max(depletion_bar.value, mana)  # Garante que a barra de dano não esteja abaixo da saúde atual

func _on_timer_timeout() -> void:
	depletion_bar.value = mana

#func update_mana_bar():
	## Atualiza a barra de mana (exemplo de chamada)
	#var max_mana = calculate_mana()
	#$CanvasLayer/ManaBar.max_value = max_mana
	#$CanvasLayer/ManaBar.value = current_mana  # current_mana seria gerenciado separadamente
