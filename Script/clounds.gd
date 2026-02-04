extends Node3D

@export var velocidade: float = 2.0      
@export var limite_distancia: float = 35.0 
@export var inicio_z: float = -80.0     

func _process(delta: float) -> void:
	
	global_position.z += velocidade * delta
	
	if global_position.z > limite_distancia:
		
		global_position.z = inicio_z
		
		global_position.x = randf_range(-10, 10)
