extends Control

onready var scrn = get_viewport().size
onready var Col = get_node("Control/VBoxContainer/color_button")
onready var anim = get_node("Control/VBoxContainer/color_button/AnimationPlayer")
onready var aud = get_node("Control/VBoxContainer/color_button/AudioStreamPlayer2D")
export (Array, Color) var cols
var i = 0
var usrpath = "user://score.dat"
onready var main = get_parent().get_parent()
var bgs = []
onready var bgb = preload("res://scenes/mmenu_scenes/bgs1.tscn")
onready var bgr = preload("res://scenes/mmenu_scenes/bgs2.tscn")
onready var pplabel = $Control/ppolicy/Label2
#onready var cols = [get_node("Sprite"), get_node("Sprite3"), get_node("Sprite4"), get_node("Sprite5"), get_node("Sprite6"), get_node("Sprite7"), get_node("Sprite8")]

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Globals.audio: $Control/TextureButton.pressed = true
	pplabel.visible = false
	Col.rect_global_position = Vector2(0, 144)
	var file = File.new()
	if file.file_exists(usrpath):
		var error = file.open_encrypted_with_pass(usrpath, File.READ, "1234")
		if error == OK:
			var dic = file.get_var()
			i = dic.i
			Globals.audio = dic.audio
			Globals.i = i
			file.close()
	change_col()
	if !Globals.audio:
		$Control/TextureButton.pressed = true
	var timer := Timer.new()
	timer.set_wait_time(0.5)
	self.add_child(timer)
	timer.start()
	for _j in range(5):
		yield (timer, "timeout")
		call_deferred("add_child", bgb.instance())
		call_deferred("add_child", bgr.instance())
	timer.queue_free()


func _on_Button_button_down():
	get_tree().change_scene("res://scenes/Main.tscn")

	
func change_col():
	Col.modulate = cols[i]
	Globals.player_col = cols[i]
	Globals.i = i


func _on_color_button_button_down():
	if i < 7:	i += 1
	elif i == 7: i = 0
	change_col()
	anim.play("shake")
	if Globals.audio:
		aud.play()

func _on_TextureButton_toggled(button_pressed):
	Globals.audio = !button_pressed


func _on_ppolicy_toggled(button_pressed):
	pplabel.visible = button_pressed
