extends Area3D

var speed = 40.0
var damage = 1

func _physics_process(delta):
	position += transform.basis.z * speed * delta

func _on_timer_timeout():
	queue_free() 

func _on_body_entered(body):
	print(body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
