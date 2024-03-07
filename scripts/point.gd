extends RigidBody2D

@onready var main = get_parent()
@onready var player = get_node("../player")
@onready var scrn = main.scrn

func _process(_delta):
	var dir = main.ppos - global_position
	if abs(dir.x) > (scrn.x / 2) + 100 || abs(dir.y) > (scrn.y / 2) + 100:
		linear_velocity = Vector2()
		global_position = Globals.randpos(main.ppos)

func _on_Area2D_body_entered(body):
	if body == player && !main.isgmovr:
		main.score(global_position, clamp(abs((body.linear_velocity - linear_velocity).length()) / 700, 0, 1), get_instance_id())
		linear_velocity = Vector2()
