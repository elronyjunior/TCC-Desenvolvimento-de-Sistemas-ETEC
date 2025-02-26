extends Control
class_name Dialogue
var message_queue:Array = []
@export var text:RichTextLabel =null
@export var timer:Timer = null
signal dialogue_finished

func show_dialogue(message:Array):
	message_queue=message
	self.show()

func add_message(message:String):
	message_queue.append(message)
func add_array_message(messages:Array):
	for message in messages:
		message_queue.append(message)
	
func _input(_event: InputEvent) -> void:
	if _event is InputEventKey && _event.is_action_pressed("NpcFala"):
		Show_message()


func Show_message():
	if(text.visible_characters < text.text.length()):
		text.visible_characters = text.text.length()
		return

	if (message_queue.size() == 0):
		self.hide()
		emit_signal("dialogue_finished")
		return
	var _msg : String = message_queue.pop_front()
	text["text"] = _msg
	text["visible_characters"]=1
	timer.start()


func LetterTime_Tick() -> void:
	if text.visible_characters == text.text.length():
		pass
	text.visible_characters += 1
