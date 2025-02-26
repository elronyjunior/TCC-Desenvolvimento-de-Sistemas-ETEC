extends Node

# Variáveis globais para experiência e níveis
var player_exp: int = 0
var player_level: int = 1
var XP_base: int = 500

# Chamado quando o jogador ganha experiência
func gain_exp(amount: int) -> void:
	player_exp += amount
	check_level_up()

# Calcula a experiência necessária para o próximo nível
func get_exp_threshold(level: int) -> int:
	return XP_base * pow(level, 2)

# Atualiza o nível do jogador com base na experiência acumulada
func check_level_up() -> void:
	while player_exp >= get_exp_threshold(player_level):
		player_exp -= get_exp_threshold(player_level)
		player_level += 1
		_on_level_up()

# Evento chamado quando o jogador sobe de nível
func _on_level_up() -> void:
	StatusPlayer.stat_points += 2
	print("Level up! Novo nível: ", player_level)
	# Aqui você pode adicionar lógica específica de level up, como ganhar pontos de status.

# Retorna a porcentagem de progresso para a barra de experiência
func get_exp_progress() -> float:
	var max_exp = get_exp_threshold(player_level)
	return float(player_exp) / max_exp
