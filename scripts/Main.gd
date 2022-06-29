extends Node2D

var ppos = Vector2()
var isgmovr = false
var hscor = 0
var scor = 0
onready var scrn = get_viewport_rect().size * 1.5
var dic = { "highscore" : 0, "i" : 0, "showfps" : false, "audio" : true}
onready var player = get_node("player")
onready var bt = $CanvasLayer/Control/bt
onready var scrtxt = get_node("CanvasLayer/Control/SC/score")
onready var hs = get_node("CanvasLayer/Control/SC/highscore")
onready var ps = preload("res://scenes/particles.tscn")
onready var tri = preload("res://Trian.tscn").instance()
onready var pause_icons = [preload("res://resources/pause_sign.png"), preload("res://resources/play_button.png")]
onready var fps = get_node("CanvasLayer/Control/SC/fpstxt")
onready var fpsshow_button = get_node("CanvasLayer/Control/showfps")
onready var anim = get_node("CanvasLayer/Control/AnimationPlayer")
const usrpath = "user://score.dat"
onready var lava := $lava
onready var lava_limit = $lava/Node2D
onready var color_rect := $CanvasLayer/Control/ColorRect
onready var shock := $CanvasLayer/Control/shockwave

func _ready():
	Globals.scrn = get_viewport().size * 1.5
	Globals.halfScrn = Vector2(int(scrn.x) >> 1, int(scrn.y) >> 1)
	if !Globals.audio: 
		$CanvasLayer/Control/audio.pressed = true
	$CanvasLayer/Control/audio.visible = false
	var point = preload("res://scenes/point.tscn")
	var enemy = preload("res://scenes/enemy.tscn")
	anim.play("RESET")
	Engine.time_scale = 1
	isgmovr = false
	bt.visible = false
	fpsshow_button.visible = false

	for i in 6:
		var poin = point.instance()
		var enm = enemy.instance()
		enm.global_position = Globals.randpos()
		poin.global_position = Globals.randpos()
		self.call_deferred("add_child", enm)
		self.call_deferred("add_child", poin)
	fps.visible = false
	loaddata()
	dic.i = Globals.i
	print(fps.visible)
	savedata()
	scrtxt.text = String(scor)
	hs.text = String(hscor)

	tri.global_position = Globals.randpos()
	self.call_deferred("add_child", tri)
	tri.set_physics_process(false)
	tri.set_process(false)
	tri.hide()

func _process(_delta):
	if fps.visible:
		fps.text = str(Engine.get_frames_per_second())
	ppos = player.global_position
	if !isgmovr:
		if ppos.y > lava_limit.global_position.y:
			gmovr()
	else:
		color_rect.color.a = lerp(color_rect.color.a, 1.0, _delta*4)
	if ppos.y < -Globals.scrn.y:
		if lava.visible: lava.visible = false
	else:
		if !lava.visible: lava.visible = true
		else: 
			lava.global_position.x = ppos.x

func gmovr():
	if Globals.audio:
		player.get_node("AudioStreamPlayer2D").play()
	dic.audio = Globals.audio
	Input.vibrate_handheld(500)
	if hscor == scor:
		dic.highscore = hscor
	savedata()
	Engine.time_scale = 0.1
	isgmovr = true
	bt.visible = true
	$Timer.stop()

func score(var pos, var vel, var id):
	var p = instance_from_id(id)
	call_deferred("remove_child", p)
	anim.play("tween")
	p.global_position = Globals.randpos(ppos)
	self.call_deferred("add_child", p)
	var psi = ps.instance()
	psi.global_position = pos
	if Globals.audio:
		psi.vol = vel
	else:
		psi.vol = 0
	add_child(psi)
	scor += 10
	if scor >= hscor:
		hscor = scor
	scrtxt.text = String(scor)
	hs.text = String(hscor)
	var _pos = player.get_global_transform_with_canvas().origin
	anim.play("shock")

#func ranpos():
#	var randpos = Vector2.ZERO
#	var dif = 50
#	randomize()
#	if rand_range(0,2) > 1:
#		randpos.x = ppos.x + rand_range(-scrn.x / 2, scrn.x / 2)
#		randomize()
#		if rand_range(0, 2) > 1:
#			randpos.y = ppos.y + scrn.y / 2 + dif
#		else:
#			randpos.y = ppos.y - scrn.y / 2 - dif
#	else:
#		randpos.y = ppos.y + rand_range(-scrn.y / 2, scrn.y / 2)
#		randomize()
#		if rand_range(0, 2) < 1:
#			randpos.x = ppos.x + scrn.x / 2 + dif
#		else:
#			randpos.x = ppos.x - scrn.x / 2 - dif
#	return randpos

func savedata():
	var file = File.new()
	var error = file.open_encrypted_with_pass(usrpath, File.WRITE, "1234")
	if error == OK:
		file.store_var(dic)
		file.close()	

func loaddata():
	var file = File.new()
	if file.file_exists(usrpath):
		var error = file.open_encrypted_with_pass(usrpath, File.READ, "1234")
		if error == OK:
			dic = file.get_var()
			hscor = dic.highscore
			#Globals.audio = dic.audio
			fps.visible = dic.showfps
			file.close()

func _on_Button_button_down():
	if isgmovr || Engine.time_scale == 0:
		savedata()
		get_tree().reload_current_scene()

func _on_Button2_button_down():
	Engine.time_scale = 1
	savedata()
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_pause_button_down():
	$CanvasLayer/Control/pause.modulate = Color(1, 1, 1, 0.86)
	$CanvasLayer/Control/pause.icon = pause_icons[1]

func _on_Timer_timeout():
	if tri.visible:
		var m = (ppos - tri.global_position)
		if abs(m.x) > (scrn.x / 2) + 100 || abs(m.y) > (scrn.y / 2) + 100:
			tri.visible = false
			tri.set_process(false)
			tri.set_physics_process(false)
	else:
		tri.visible = true
		tri._ready()
		tri.set_process(true)
		tri.set_physics_process(true)

func _on_showfps_button_down():
	if !fps.visible:
		fpsshow_button.modulate = Color(1.2, 1.2, 1.2, 1)
		fps.visible = true
	else:
		fps.visible = false
		fpsshow_button.modulate = Color(1, 1, 1, 0.86)
	dic.showfps = fps.visible
	print(fps.visible)

func _on_pause_button_up():
	if Engine.time_scale == 1:
		$CanvasLayer/Control/pause.modulate = Color(1,1,1,1)
		Engine.time_scale = 0
		bt.visible = true
		fpsshow_button.visible = true
		$CanvasLayer/Control/audio.visible = true
	elif Engine.time_scale == 0:
		$CanvasLayer/Control/pause.icon = pause_icons[0]
		$CanvasLayer/Control/pause.modulate = Color(1.2,1.2,1.2,1)
		Engine.time_scale = 1
		bt.visible = false
		fpsshow_button.visible = false
		$CanvasLayer/Control/audio.visible = false
	print(fps.visible)


func _on_watchad_button_down():
	#play ad
	$CanvasLayer/Control/bt/watchad.text = "Ads are not available at the moment"
	pass


func _on_audio_toggled(button_pressed):
	Globals.audio = !button_pressed

func _on_lava_body_entered(body):
	if body == player:
		gmovr()
