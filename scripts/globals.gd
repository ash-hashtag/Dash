extends Node

@onready var scrn = get_viewport().size
@onready var halfScrn = Vector2(int(scrn.x) >> 1, int(scrn.y) >> 1)
var player_col = Color(1,1,1,1)
var i = 0
var audio = true
var hscor = 0
var fps = false
	

func randpos(ppos = Vector2.ZERO, ontop = false):
	var rpos = Vector2.ZERO
	var dif = 50
	randomize()
	if ontop:
		rpos.x = ppos.x + randf_range(-halfScrn.x-500, halfScrn.x)
		randomize()
		rpos.y = ppos.y - halfScrn.y - dif
	elif randf_range(0,2) > 1:
		rpos.x = ppos.x + randf_range(-halfScrn.x, halfScrn.x)
		randomize()
		if randf_range(0, 2) > 1:
			rpos.y = ppos.y + halfScrn.y + dif
		else:
			rpos.y = ppos.y - halfScrn.y - dif
	else:
		rpos.y = ppos.y + randf_range(-halfScrn.y, halfScrn.y)
		randomize()
		if randf_range(0, 2) < 1:
			rpos.x = ppos.x + halfScrn.x + dif
		else:
			rpos.x = ppos.x - halfScrn.x - dif
	return rpos
