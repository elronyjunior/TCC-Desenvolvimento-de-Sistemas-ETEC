extends Area2D
@export var animation_tree:AnimationTree=null
@export var surgir:float = 0.3
@export var speed:float =5
@export var Sprite:Sprite2D=null
@export var sumir:Timer=null
var quebrou:bool=false



var state_machine
var direction:Vector2 
# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine= animation_tree["parameters/playback"]
	sumir.start()
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
		queue_free()


func _on_area_entered(area):
	if(area.is_in_group("inimigo")):
		queue_free()
