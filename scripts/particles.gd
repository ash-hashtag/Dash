extends GPUParticles2D

var vol

func _ready():
	$AudioStreamPlayer2D.volume_db = linear_to_db(vol)
	emitting = true

func _on_Timer_timeout():
	queue_free()
