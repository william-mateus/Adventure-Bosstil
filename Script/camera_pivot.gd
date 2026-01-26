extends Node3D

@export var smooth_speed : float = 10.0
@export var mouse_sensitivity : float = 5.0 # Distância que a câmera desvia

var player : Node3D

func _ready():
	# Busca o player pelo nome exato da sua imagem
	player = get_parent().get_node("CharacterBody3D")

func _process(delta):
	if not player: return

	var target_pos = player.global_position
	
	# Pega a posição do mouse em relação ao centro da tela
	var screen_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Normaliza: Centro da tela vira (0,0), bordas viram -1 ou 1
	var look_at_mouse = Vector2(
		(mouse_pos.x - screen_size.x / 2) / (screen_size.x / 2),
		(mouse_pos.y - screen_size.y / 2) / (screen_size.y / 2)
	)

	# Aplica o deslocamento. Se look_at_mouse for (0,0), o offset é zero.
	var offset = Vector3(look_at_mouse.x, 0, look_at_mouse.y) * mouse_sensitivity
	
	var final_pos = target_pos + offset
	global_position = global_position.lerp(final_pos, smooth_speed * delta)
