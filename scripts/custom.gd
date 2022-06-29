extends Button

var cl = true


func _ready():
	rect_global_position.y = get_parent().get_node("VBoxContainer/color_button").rect_global_position.y
	modulate = Color(1, 1, 1, 0.5)

func _on_custom_button_down():
	if cl:
		$Label.text = "Watch 100 ads to unlock"
	else:
		$Label.text = "Locked"
	cl = !cl
	get_parent().get_node("VBoxContainer/color_button/AudioStreamPlayer2D").play()

