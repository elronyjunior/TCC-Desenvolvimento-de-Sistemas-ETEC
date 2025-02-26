extends ProgressBar

func _ready():
	update_exp_bar()

func _physics_process(_delta):
	update_exp_bar()
	check_level_up()

func gain_exp(amount: int):
	LevelManager.player_exp += amount
	while LevelManager.player_exp >= get_exp_threshold(LevelManager.player_level):
		LevelManager.player_exp -= get_exp_threshold(LevelManager.player_level)
		LevelManager.player_level += 1
		_on_level_up()
	update_exp_bar()

func update_exp_bar():
	$".".max_value = get_exp_threshold(LevelManager.player_level)
	$".".value = LevelManager.player_exp

func check_level_up():
	while LevelManager.player_exp >= get_exp_threshold(LevelManager.player_level):
		LevelManager.player_exp -= get_exp_threshold(LevelManager.player_level)
		LevelManager.player_level += 1
		_on_level_up()

func get_exp_threshold(level: int) -> int:
	return LevelManager.XP_base * pow(level, 2)

func _on_level_up():
	print("Parabéns! Você subiu para o nível ", LevelManager.player_level)
