extends Control

# Referência para o rótulo de pontos disponíveis
@onready var player = get_node("/root/StatusPlayer")
@onready var node_stat_points = get_node("HBoxContainer/VBoxContainer/HBoxContainer/MainStats/HBoxContainer/LblPontos")
var path_main_stats = "HBoxContainer/VBoxContainer/HBoxContainer/MainStats"
var path_derived_stats = "HBoxContainer/VBoxContainer/HBoxContainer/DerivedStats"
var healthbar: Healthbar
var manabar: Manabar

@export var animation: AnimatedSprite2D = null

# Pontos disponíveis
var available_points
var forca_add = 0
var inteligencia_add = 0
var vitalidade_add = 0
var defesa_add = 0
var sorte_add = 0

# Dicionário mapeando classes para animações
var class_animations = {
	0: "Arqueira",  # Nome da animação para a arqueira
	1: "Guerreiro",  # Nome da animação para o guerreiro
	2: "Feiticeira",  # Nome da animação para a feiticeira
	3: "Lanceiro"    # Nome da animação para o lanceiro
}


func _ready():
	LoadStats()
	available_points = player.stat_points
	node_stat_points.set_text(str(available_points) + " Points")
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("MaxButtons"):
			button.set_disabled(false)
	for button in get_tree().get_nodes_in_group("MaxButtons"):
		if button and button.get_node("../.."):  # Verifica validade
			button.set_disabled(available_points == 0)
			button.connect("pressed", Callable(self, "IncreaseStat").bind(button.get_node("../..").get_name()))

	for button in get_tree().get_nodes_in_group("MinButtons"):
		if button and button.get_node("../.."):  # Verifica validade
			button.set_disabled(true)
			button.connect("pressed", Callable(self, "DecreaseStat").bind(button.get_node("../..").get_name()))

func LoadStats():
	# Carrega os valores diretamente do StatusPlayer
	get_node(path_main_stats + "/Forca/StatusBackground/status/value").set_text(str(StatusPlayer.Forca))
	get_node(path_main_stats + "/Vitalidade/StatusBackground/status/value").set_text(str(StatusPlayer.Vitalidade))
	get_node(path_main_stats + "/Defesa/StatusBackground/status/value").set_text(str(StatusPlayer.Defesa))
	get_node(path_main_stats + "/Inteligencia/StatusBackground/status/value").set_text(str(StatusPlayer.Inteligencia))
	get_node(path_main_stats + "/Sorte/StatusBackground/status/value").set_text(str(StatusPlayer.Sorte))

	# Atualiza as estatísticas derivadas
	UpdateDerivedStats()

func UpdateDerivedStats():
	# Calcula e atualiza os valores derivados
	get_node(path_derived_stats + "/VBoxContainer/Vida/value").text = str((StatusPlayer.Vitalidade + vitalidade_add) * 1.5)
	get_node(path_derived_stats + "/VBoxContainer/Attack/value").text = str((StatusPlayer.Forca + forca_add) * 1.5)
	get_node(path_derived_stats + "/VBoxContainer/Defesa/value").text = str((StatusPlayer.Defesa + defesa_add) * 1.5)
	get_node(path_derived_stats + "/VBoxContainer/Mana/value").text = str((StatusPlayer.Inteligencia + inteligencia_add) * 1.5)
	get_node(path_derived_stats + "/VBoxContainer/Sorte/value").text = str((StatusPlayer.Sorte + sorte_add) * 1.5)

	# Atualiza a barra de vida
	var new_max_health = 10 + (StatusPlayer.Vitalidade + vitalidade_add) * 1.5
	if is_instance_valid(healthbar):
		healthbar.max_value = new_max_health
		healthbar.value = min(healthbar.value + (vitalidade_add * 1.5), new_max_health)  # Atualiza a saúde regenerada
		
	var new_max_mana = 10 + (StatusPlayer.Inteligencia + inteligencia_add) * 1.5
	if is_instance_valid(manabar):
		manabar.max_value = new_max_mana
		manabar.value = min(manabar.value + (inteligencia_add * 1.5), new_max_mana)  # Atualiza a saúde regenerada

# Função para aumentar um atributo
func IncreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	get_node(path_main_stats + "/" + stat + "/StatusBackground/status/change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	get_node(path_main_stats + "/" + stat + "/StatusBackground/min").set_disabled(false)
	available_points -= 1
	node_stat_points.set_text(str(available_points) + " points")
	if available_points == 0:
		for button in get_tree().get_nodes_in_group("MaxButtons"):
			button.set_disabled(true)
	UpdateDerivedStats()

# Função para diminuir um atributo
func DecreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") - 1)
	if get(stat.to_lower() + "_add") == 0:
		get_node(path_main_stats + "/" + stat + "/StatusBackground/min").set_disabled(true)
		get_node(path_main_stats + "/" + stat + "/StatusBackground/status/change").set_text(" ")
	else:
		get_node(path_main_stats + "/" + stat + "/StatusBackground/status/change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	available_points += 1
	node_stat_points.set_text(str(available_points) + " Points")
	for button in get_tree().get_nodes_in_group("MaxButtons"):
		button.set_disabled(false)
	UpdateDerivedStats()

func _on_btn_confirm_pressed() -> void:
	if forca_add + vitalidade_add + defesa_add + inteligencia_add + sorte_add == 0:
		print("Nothing to confirm, add your pop-up here if desired")
	else:
		StatusPlayer.stat_points = available_points
		StatusPlayer.Forca += forca_add
		StatusPlayer.Vitalidade += vitalidade_add
		StatusPlayer.Defesa += defesa_add
		StatusPlayer.Inteligencia += inteligencia_add
		StatusPlayer.Sorte += sorte_add
		
		if inteligencia_add > 0:
			_mana()
		if vitalidade_add > 0:
			_vida()
		
		# Reseta os incrementos temporários
		forca_add = 0
		vitalidade_add = 0
		defesa_add = 0
		inteligencia_add = 0
		sorte_add = 0

		LoadStats()  # Recarrega os atributos para refletir as mudanças

	# Desativa os botões de decremento
	for button in get_tree().get_nodes_in_group("MinButtons"):
		button.set_disabled(true)

	# Reseta os rótulos de alteração
	for label in get_tree().get_nodes_in_group("ChangeLabels"):
		label.set_text("")

func get_status_classe():
	var status_container = get_node("HBoxContainer/VBoxContainer")
	var indice: int = 0
	var player_stats = [
		StatusPlayer.Vitalidade,
		StatusPlayer.Defesa,
		StatusPlayer.Forca,
		StatusPlayer.Sorte,
		StatusPlayer.Inteligencia
	]
	for valores in Global.acha_filhos("Label", ["Label", "LblVitalidade", "LblDefesa", "LblForca", "LblSorte", "LblInteligencia"], status_container):
		valores.text = str(player_stats[indice])
		indice += 1
	
	# Atualiza o AnimatedSprite2D com base na classe selecionada
	if animation:
		var class_animation = class_animations.get(StatusPlayer.selected_class, "")
		if class_animation != "":
			animation.play(class_animation)
		else:
			print("Nenhuma animação definida para a classe selecionada!")

func _mana():
	# Incrementa o valor atual de mana com base nos pontos adicionados
	var mana_increase = inteligencia_add * 1.5
	Global.maxMana = 10 + (StatusPlayer.Inteligencia * 1.5)  # Atualiza o maxMana
	Global.mana = clamp(Global.mana + mana_increase, 0, Global.maxMana)  # Incrementa a mana atual
	if is_instance_valid(manabar):
		manabar.update_max_mana(Global.maxMana)
		manabar._set_mana(Global.mana)

func _vida():
	# Incrementa o valor atual de vida com base nos pontos adicionados
	var health_increase = vitalidade_add * 1.5
	Global.maxHealth = 10 + (StatusPlayer.Vitalidade * 1.5)  # Atualiza o maxHealth
	Global.health = clamp(Global.health + health_increase, 0, Global.maxHealth)  # Incrementa a vida atual
	if is_instance_valid(healthbar):
		healthbar.update_max_health(Global.maxHealth)
		healthbar._set_health(Global.health)
