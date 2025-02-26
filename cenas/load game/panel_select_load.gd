extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in Global.acha_filhos("PanelContainer"):
		for text_panel in Global.acha_filhos("Label",[],i):
			text_panel["theme_override_font_sizes/font_size"]=Global.proporcional(14,30)
