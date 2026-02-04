extends Area3D

var speed = 40.0
var damage = 1

func _physics_process(delta):
	position -= transform.basis.z * speed * delta

func _on_timer_timeout():
	queue_free() # Apaga a bala após X segundos para não pesar o jogo
