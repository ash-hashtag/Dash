extends Node

onready var scrn = get_viewport().size
onready var halfScrn = Vector2(int(scrn.x) >> 1, int(scrn.y) >> 1)
var player_col = Color(1,1,1,1)
var i = 0
var audio = true
var hscor = 0
var fps = false
	

func randpos(ppos = Vector2.ZERO, ontop = false):
	var randpos = Vector2.ZERO
	var dif = 50
	randomize()
	if ontop:
		randpos.x = ppos.x + rand_range(-halfScrn.x-500, halfScrn.x)
		randomize()
		randpos.y = ppos.y - halfScrn.y - dif
	elif rand_range(0,2) > 1:
		randpos.x = ppos.x + rand_range(-halfScrn.x, halfScrn.x)
		randomize()
		if rand_range(0, 2) > 1:
			randpos.y = ppos.y + halfScrn.y + dif
		else:
			randpos.y = ppos.y - halfScrn.y - dif
	else:
		randpos.y = ppos.y + rand_range(-halfScrn.y, halfScrn.y)
		randomize()
		if rand_range(0, 2) < 1:
			randpos.x = ppos.x + halfScrn.x + dif
		else:
			randpos.x = ppos.x - halfScrn.x - dif
	return randpos
