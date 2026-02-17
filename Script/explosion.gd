extends Node3D

@onready var sparkles: GPUParticles3D = $sparkles
@onready var explosion_particles: GPUParticles3D = $explosion
@onready var smoke: GPUParticles3D = $smoke
@onready var som_player: AudioStreamPlayer = %som_player


@export var lista_de_sons : Array[AudioStream] = []

func _ready() -> void:
	
	sparkles.emitting = true
	explosion_particles.emitting = true
	smoke.emitting = true
	
	tocar_som_aleatorio()
	
	# Auto-destruição
	await get_tree().create_timer(3.0).timeout
	queue_free()

func tocar_som_aleatorio():
	if lista_de_sons.size() > 0:
		# Escolhe um índice aleatório da lista
		var som_escolhido = lista_de_sons.pick_random()
		som_player.stream = som_escolhido
		
		# Pequeno truque profissional: Variar o Pitch (tom)
		# Isso faz com que mesmo o mesmo som pareça diferente cada vez
		som_player.pitch_scale = randf_range(0.8, 1.2)
		
		som_player.play()
