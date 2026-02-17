extends CharacterBody3D

var speed = 2.0
var health = 1
var posicao_cerca : Vector3
var morreu := false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D	
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@export var explosion:PackedScene

func _physics_process(delta):
	if morreu:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	# força a spwnar no chao o miseral
	local_destination.y = 0
	var direction = local_destination.normalized()

	if direction.length() > 0.01:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# --- CORREÇÃO DE ROTAÇÃO (CORRER DE FRENTE) ---
		# Se ele anda de costas, usamos o sinal de MENOS (-) antes da direction
		# Isso faz ele rotacionar 180 graus em relação ao caminho.
		var look_direction = -direction 
		var look_target = global_position + look_direction
		
		look_at(look_target, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	atualizar_animacao()

func _ready() -> void:
	call_deferred("setup_nav")

func setup_nav():
	navigation_agent_3d.target_position = posicao_cerca

func atualizar_animacao():
	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	if horizontal_velocity > 0.1:
		trocar_animacao("Armature|Running")
	else:
		trocar_animacao("Armature|Idle_talking")

func trocar_animacao(nome: String):
	if animation_player.current_animation != nome:
		animation_player.play(nome)

func take_damage(amount):
	if morreu: return
	health -= amount
	if health <= 0:
		morrer_inimigo()

func morrer_inimigo():
	if morreu: return
	morreu = true
	
	if explosion:
		var nova_explosao = explosion.instantiate()
		get_tree().current_scene.add_child(nova_explosao)
		nova_explosao.global_position = global_position
	
	remove_from_group("inimigos_vivos")
	velocity = Vector3.ZERO
	
	# DECISÃO = (Consultar opnioes sobre esse mortal)
	#if animation_player.has_animation("Armature|Mortal"):
		#animation_player.play("Armature|Mortal")
		#await animation_player.animation_finished
	
	queue_free()

func _on_navigation_agent_3d_target_reached() -> void:
	if morreu: return
	velocity = Vector3.ZERO
	animation_player.play("Armature|Idle_talking")
