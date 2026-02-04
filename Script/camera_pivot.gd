extends Node3D

@export var player : Node3D
@export var sensitivity : float = 0.5

@export_group("Configurações de Zoom Dinâmico")
@export var zoom_speed : float = 2.0
@export var min_zoom : float = 4.0   # Perto e baixo
@export var max_zoom : float = 15.0  # Longe e alto
@export var smooth_speed : float = 8.0

var target_zoom_factor : float = 0.5 # 0 é o mais perto, 1 é o mais longe
@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Rotação horizontal
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
	
	# Scroll altera o fator de zoom (entre 0 e 1)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom_factor -= 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom_factor += 0.1
		
		target_zoom_factor = clamp(target_zoom_factor, 0.0, 1.0)

func _process(delta):
	if player:
		global_position = player.global_position
	
	if camera:
		# 1. Calculamos os valores ideais baseados no fator de zoom
		# Quando target_zoom_factor é 0 -> Usa os primeiros valores (perto)
		# Quando target_zoom_factor é 1 -> Usa os segundos valores (longe)
		
		var target_z = lerp(min_zoom, max_zoom, target_zoom_factor)
		var target_y = lerp(2.0, 12.0, target_zoom_factor) # Sobe quando afasta
		var target_x_rot = lerp(-25.0, -75.0, target_zoom_factor) # Inclina mais para baixo quando afasta
		
		# 2. Aplicamos suavemente na câmera
		camera.position.z = lerp(camera.position.z, target_z, smooth_speed * delta)
		camera.position.y = lerp(camera.position.y, target_y, smooth_speed * delta)
		
		# Ajusta a rotação X (inclinação) para olhar mais para baixo conforme sobe
		var current_rot = camera.rotation_degrees
		current_rot.x = lerp(current_rot.x, target_x_rot, smooth_speed * delta)
		camera.rotation_degrees = current_rot
