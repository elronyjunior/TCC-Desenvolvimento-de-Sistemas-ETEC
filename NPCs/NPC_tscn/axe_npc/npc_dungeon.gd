extends CharacterBody2D

var obj_Dialogue = Dialogue.new()
var colidiu: Array = [false, false]
@export var aviso: Sprite2D = null
@export var animation: AnimatedSprite2D = null

var inimigos_derrotados: int = 0  # Contador de inimigos derrotados
const INIMIGOS_PARA_PASSAR: int = 10  # Quantidade necessária para passar de fase
var missao_iniciada: bool = false  # Controle da missão

func _ready() -> void:
	animation.play("default")
	# Conecta o sinal `enemy_died` de cada inimigo
	for inimigo in get_tree().get_nodes_in_group("inimigo"):
		if inimigo.has_signal("enemy_died"):
			inimigo.enemy_died.connect(enemy_died)
		else:
			print("Inimigo não possui o sinal 'enemy_died': ", inimigo)

func _physics_process(_delta: float) -> void:
	if not colidiu[0]:
		aviso.hide()
	
	if Input.is_action_just_pressed("interagir") and colidiu[1]:
		if get_node("/root").get_child(11).find_child("UI").get_child(11) == null:
			var caixa_dialogo = load("res://NPCs/dialogue/Dialogue.tscn").instantiate()
			
			if not missao_iniciada:
				# Diálogo inicial
				caixa_dialogo.text.text = "Você foi jogado aqui também?"
				caixa_dialogo.add_array_message([
					"Irei te passar uma missão.",
					"Se você matar 10 inimigos aqui presentes, eu te tiro desse lugar.",
					"Hahaha, isso se você conseguir!"
				])
				missao_iniciada = true
			elif inimigos_derrotados >= INIMIGOS_PARA_PASSAR:
				# Diálogo final ao completar a missão
				caixa_dialogo.text.text = "Parabéns!"
				caixa_dialogo.add_array_message([
					"Você conseguiu derrotar todos os inimigos.",
					"Agora vou cumprir minha promessa e te tirar daqui!"
				])
			else:
				# Feedback se não completou a missão
				caixa_dialogo.text.text = "Você ainda não terminou!"
				caixa_dialogo.add_array_message([
					"Continue lutando. Você precisa derrotar 10 inimigos."
				])
			
			get_node("/root").get_child(11).find_child("UI").add_child(caixa_dialogo)
			caixa_dialogo.dialogue_finished.connect(dialogue_finished)

func dialogue_finished():
	if inimigos_derrotados >= INIMIGOS_PARA_PASSAR:
		print("Missão completa! Mudando para a próxima fase.")
		get_tree().change_scene_to_file("res://levels/scenes/test_level.tscn")
	else:
		print("Você ainda não derrotou inimigos suficientes!")

func enemy_died():
	inimigos_derrotados += 1
	print("Inimigos derrotados: %d/%d".format([inimigos_derrotados, INIMIGOS_PARA_PASSAR]))

func _on_body_aviso_area_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		colidiu[0] = true
		aviso.show()

func _on_body_aviso_area_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		colidiu[0] = false
		aviso.hide()
		if get_node("/root").get_child(11).find_child("UI").get_child(11) != null:
			get_node("/root").get_child(11).find_child("UI").get_child(11).queue_free()

func _on_body_interação_area_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		colidiu[1] = true

func _on_body_interação_area_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		colidiu[1] = false
