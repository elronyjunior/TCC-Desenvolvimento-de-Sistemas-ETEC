extends Area2D
@export var animation_tree:AnimationTree=null
@export var surgir:float = 0.3
@export var speed:float =1
@export var fire_bullet:Sprite2D=null
@export var sumir:Timer=null
@export var animated:AnimatedSprite2D=null
@export var slime: Slime = Slime.new()
var quebrou:bool=false



var state_machine
var direction:Vector2 
# Called when the node enters the scene tree for the first time.
func _ready():
	fire_bullet.texture=preload("res://projeteis/fire_bullet/fire loop.png")
	animated.play("default")
	state_machine= animation_tree["parameters/playback"]
	sumir.start()
	state_machine.travel("fire")
func _process(_delta):
	move()
func set_direction(dir:Vector2):
	var vazio:bool=false
	direction=dir
	if(!vazio):
		if(dir[0]==-1 && dir[1]==-1):
			self.rotate(5*PI/4)
			
		elif(dir[0]==-1 && dir[1]==1):
			self.rotate(3*PI/4)
		elif(dir[0]==1 && dir[1]==1):
			self.rotate(PI/4)
		elif(dir[0]==1 && dir[1]==-1):
			self.rotate(7*PI/4)
		elif(dir[0]==-1):
			self.scale.x=self.scale.x*-1
		elif(dir[1]==-1):
			self.rotate(PI/2*-1)
		elif(dir[1]==1):
			self.rotate(PI / 2)	

func move():
	if(quebrou):
		speed=0.1
	position.x=position.x+ direction.normalized().x * speed
	position.y=position.y+ direction.normalized().y * speed


func _on_sumir_timeout():
	queue_free()

func _on_body_entered(body):
	if(body.is_in_group("inimigo")):
		body.update_health()
		state_machine.travel("destroy")
		animated.play("destroy")
		quebrou=true


func _on_area_entered(area):
	if(area.is_in_group("inimigo")):
		state_machine.travel("destroy")
		animated.play("destroy")
		quebrou=true
		
		


func _on_animated_sprite_2d_animation_finished():
	if(quebrou):
		queue_free()
