extends Node3D

@onready var sparkles: GPUParticles3D = $sparkles
@onready var explosion_particles: GPUParticles3D = $explosion # cuidado com conflito de nomes (nó vs variável)
@onready var smoke: GPUParticles3D = $smoke

func _ready() -> void:
	sparkles.emitting = true
	explosion_particles.emitting = true
	smoke.emitting = true
	
	# Espera 3 segundos e some com o efeito do mapa
	await get_tree().create_timer(3.0).timeout
	queue_free()
