extends KinematicBody2D


var i = true
onready var main = get_parent()
onready var pos = get_node("Position2D")
onready var line = get_node("Line2D")
onready var aud = $AudioStreamPlayer2D
var fixd_rot = Vector2()
var fixd_dir = Vector2()

func _ready():
	if i:
		visible = false
		$CollisionPolygon2D.disabled = true
		i = false
	else:
		visible = true
		$CollisionPolygon2D.disabled = false
		global_position = Globals.randpos(main.ppos)
		look_at(main.ppos)
		if Globals.audio:
			aud.play()
		line.clear_points()
		fixd_dir = (main.ppos - global_position).normalized() * 20
		fixd_rot = global_rotation

func _process(delta):
	if visible && Engine.time_scale != 0:
		move_and_collide(fixd_dir)
		if global_rotation != fixd_rot:	global_rotation = fixd_rot
		line.global_position = Vector2.ZERO
		line.global_rotation = 0
		line.add_point(pos.global_position)
		while line.get_point_count() > (1 / (delta + 0.001)) * Engine.time_scale:
			line.remove_point(0)

