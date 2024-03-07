extends RigidBody2D

var strtpos = Vector2()
var curpos = Vector2()
@onready var line = get_node("Line2D")
@onready var sprite = get_node("plyr")
var dir := Vector2()
@export var vel := 4
@onready var aims = [get_node("Sprite2"), get_node("Sprite3"), get_node("Sprite4"), get_node("Sprite5")]
const t = 0.15
const g = Vector2(0, -9.8)

func _ready():
#	aims = [aim1, aim2, aim3, aim4]
	for i in 4:
		aims[i].global_position = global_position
		aims[i].global_rotation = 0
		aims[i].visible = false
	line.gradient.colors[0] = Color(0,0,0,0)
	line.gradient.colors[1] = Globals.player_col
	sprite.self_modulate = Globals.player_col * 1.04

func _process(delta):
	
	line.global_position = Vector2.ZERO
	line.global_rotation = 0
	line.add_point(global_position)
	while line.get_point_count() > Engine.get_frames_per_second() * Engine.time_scale:
		line.remove_point(0)
		
	if Engine.time_scale == 1:
		if Input.is_action_just_pressed("touch"):
			strtpos = _mouse_position()
			for i in 4:
				aims[i].visible = true
				
		if Input.is_action_pressed("touch"):
			curpos = _mouse_position()
			dir = curpos - strtpos	
			for i in 4:
				aims[i].global_position = global_position + dir * vel * t * (i + 1) - 0.5 * g * t * t * (i + 1)
			
		if Input.is_action_just_released("touch"):
			if strtpos != Vector2.ZERO:
				curpos = _mouse_position()
				dir = curpos - strtpos
				var vel = dir * vel
				print("Moving Player " + str(vel))
				linear_velocity = vel
				#move_and_collide(vel)
				for i in 4:
					aims[i].visible = false
	elif aims[0].visible:
		for i in 4:
			aims[i].visible = false


func _mouse_position() -> Vector2:
	return DisplayServer.mouse_get_position()
