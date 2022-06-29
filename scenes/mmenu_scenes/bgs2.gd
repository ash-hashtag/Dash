extends Sprite


var dir = Vector2()
var init = Vector2()
var n = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if !n:
		init = global_position
		n = true
	global_position = init
	dir = Vector2(1, tan(global_rotation)).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position+=dir
	if abs(global_position.x) > Globals.scrn.x/2 +50|| abs(global_position.y) > Globals.scrn.y/2 +50:
		_ready() 
