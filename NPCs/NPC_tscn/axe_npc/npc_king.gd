extends CharacterBody2D
var obj_Dialogue= Dialogue.new()
var colidiu:Array=[false,false]
@export var aviso:Sprite2D=null
@export var animation:AnimatedSprite2D=null
func _ready() -> void:
	animation.play("default")
	print(get_node("/root").get_child(10))
	

func _physics_process(_delta: float) -> void:
	if(colidiu[0]==false):
		aviso.hide()
	if(Input.is_action_just_pressed("interagir") && colidiu[1]):
		if(get_node("/root").get_child(11).find_child("UI").get_child(11)==null):
			var caixa_dialogo=load("res://NPCs/dialogue/Dialogue.tscn").instantiate()
			caixa_dialogo.text.text = "Você foi escolhido para ser o heroi desse mundo."
			caixa_dialogo.add_array_message([
				"Espera, o que é isso?!",
				"O que são esses status?? São ridiculos!",
				"Guardas, joguem esse ser fraco na masmorra!!"
			])
			get_node("/root").get_child(11).find_child("UI").add_child(caixa_dialogo)
			caixa_dialogo.dialogue_finished.connect(dialogue_finished)

func dialogue_finished():
	get_tree().change_scene_to_file("res://levels/scenes/dungeon_level.tscn")
func _on_body_aviso_area_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		colidiu[0]=true
		aviso.show()
	


func _on_body_aviso_area_exited(body: Node2D) -> void:
	if(body.is_in_group("player")):
		colidiu[0]=false
		aviso.hide()
		print()
		if(get_node("/root").get_child(11).find_child("UI").get_child(11) != null):
			get_node("/root").get_child(11).find_child("UI").get_child(11).queue_free()


func _on_body_interação_area_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		colidiu[1]=true


func _on_body_interação_area_exited(body: Node2D) -> void:
	if(body.is_in_group("player")):
		colidiu[1]=false

	
