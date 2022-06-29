extends RigidBody2D

onready var main = get_parent()
onready var player = get_node("../player")
onready var line = get_node("Line2D")
var dir

func _process(delta):
	dir = main.ppos - global_position
	linear_velocity = dir.normalized() * 100
	line.global_position = Vector2.ZERO
	line.global_rotation = 0
	line.add_point(global_position)
	while line.get_point_count() > (1 / (delta + 0.001)):
		line.remove_point(0)
	
	if abs(dir.x) > (Globals.halfScrn.x) + 100 || abs(dir.y) > (Globals.halfScrn.y) + 100:
		line.clear_points()
		global_position = Globals.randpos(main.ppos)


func _on_Area2D_body_entered(body):
	if body == player && !main.isgmovr:
		main.gmovr()
