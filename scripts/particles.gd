extends Particles2D

var vol

func _ready():
	$AudioStreamPlayer2D.volume_db = linear2db(vol)
	emitting = true

func _on_Timer_timeout():
	queue_free()
