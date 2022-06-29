extends Sprite

var dir = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Globals.randpos(Globals.halfScrn, true)
	dir = Vector2(1, tan(global_rotation)).normalized()


func _process(delta):
	global_position += dir* delta* 120
	if abs(global_position.x) > Globals.scrn.x+300|| abs(global_position.y) > Globals.scrn.y +200:
		_ready() 
