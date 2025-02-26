extends CharacterBody2D
var state_machine
var is_attackin:bool=false
var direction:Vector2 =Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_up")
		)
@onready var player = $"."
@onready var marker_2d = $Marker2D
@onready var ice_timer = $ice_timer
@export_category("movimento")
@export var move_speed:float =64
@export var aceleration:float=0.4
@export var friction:float=0.8
@export_category("objetos")
@export var animation_tree: AnimationTree = null 
@export var attack_timer: Timer = null

func _ready():
	state_machine= animation_tree["parameters/playback"]
func _physics_process(_delta):
	Global.time= int(ice_timer.time_left)
	if(Input.is_action_just_pressed("ice") && !Global.ice_coldown):
		Global.ice_coldown=true
		ice_timer.start()
		#projeteis("ice")
	#direcao()
	attack()
	animated()
	move()
	move_and_slide()
func move():
	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/BlendSpace2D/blend_position"]=direction
		animation_tree["parameters/walk/BlendSpace2D/blend_position"]=direction
		animation_tree["parameters/attack/BlendSpace2D/blend_position"]=direction
		velocity.x=lerp(velocity.x, direction.normalized().x * move_speed,aceleration)
		velocity.y=lerp(velocity.y, direction.normalized().y * move_speed,aceleration)
		return
	velocity.x=lerp(velocity.x, direction.normalized().x * move_speed,friction)
	velocity.y=lerp(velocity.y, direction.normalized().y * move_speed,friction)
func attack():
	if (Input.is_action_just_pressed("attack") && is_attackin == false):
		set_physics_process(false)
		attack_timer.start()
		is_attackin=true
	if (Input.is_action_just_pressed("attack") && is_attackin == false):
		set_physics_process(false)
		attack_timer.start()
		is_attackin=true
func animated():
	if(is_attackin==true):
		state_machine.travel("attack")
		return
	if(velocity.length()>2):
		state_machine.travel("walk")
		return
	state_machine.travel("idle")
