extends Node2D
var objdata=PlayerData.new()
var dictionary={0:["banan"]}
@export var animation:AnimationPlayer=null

func _ready():
	for i in ["banana","alicia","arthur","marcela","arthur"]:
		if(i == "arthur"):
			break
		print(i)
func _process(delta):
	pass
 
