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
			caixa_dialogo.text.text="Deixa eu te contar um coisinha."
			caixa_dialogo.add_array_message(
			[
			"fui mandado para esse lugar imundo",
			"por favor! me ajude a matar esses nojentos gosmentos",
			"eca! eca! eca! acho que um encostou em mim que nojo!!"
			])
			get_node("/root").get_child(11).find_child("UI").add_child(caixa_dialogo)

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

	
