extends CharacterBody3D

# --- CONFIGURAÇÕES ---
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const IDLE_SPECIAL_TIME = 40.0 
const COMBAT_DURATION = 3.0 

# --- REFERÊNCIAS ---
@export var bullet_scene : PackedScene 
@export var camera_pivot : Node3D 

# REFERÊNCIAS COM NOME ÚNICO (%)
@onready var visual_model = %Armature # CERTIFIQUE-SE QUE O NOME NA ÁRVORE É EXATAMENTE 'Armature'
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var muzzle: Marker3D = %Muzzle 

# Áudios com Nome Único (%)
@onready var running_effects: AudioStreamPlayer = %running_effects
@onready var capoeira_effects: AudioStreamPlayer = %capoeira_effects

var idle_timer = 0.0
var combat_timer = 0.0

func _physics_process(delta: float) -> void:
	if camera_pivot == null: return

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Lógica de Atirar
	if Input.is_action_just_pressed("click_esquerdo"):
		shoot()
		combat_timer = COMBAT_DURATION 

	if combat_timer > 0:
		combat_timer -= delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimentação
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cam_basis = camera_pivot.global_transform.basis
	var forward = -cam_basis.z 
	var right = cam_basis.x
	forward.y = 0; right.y = 0
	forward = forward.normalized(); right = right.normalized()
	
	var direction = (forward * -input_dir.y + right * input_dir.x).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Toca som de corrida
		if running_effects and not running_effects.playing:
			running_effects.play()
		
		# Animações
		if animator:
			if combat_timer > 0: animator.play("Armature|run_pistola")
			else: animator.play("Armature|running")
			
		# ROTAÇÃO (Onde dava o erro)
		if visual_model:
			var target_angle = atan2(direction.x, direction.z)
			visual_model.rotation.y = lerp_angle(visual_model.rotation.y, target_angle, 10.0 * delta)
		
		idle_timer = 0.0
		if capoeira_effects: capoeira_effects.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if running_effects: running_effects.stop()
		
		idle_timer += delta
		
		if idle_timer >= IDLE_SPECIAL_TIME:
			if animator: animator.play("Armature|idle_capoeira")
			if capoeira_effects and not capoeira_effects.playing:
				capoeira_effects.play()
		else:
			if animator: animator.play("Armature|idle") 
			if capoeira_effects: capoeira_effects.stop()

	move_and_slide()

func shoot():
	if bullet_scene == null: return
	
	var target_muzzle = muzzle if muzzle else get_node_or_null("%Muzzle")
	
	if target_muzzle:
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		
		# Posição vem da mão
		b.global_position = target_muzzle.global_position
		
		# Rotação vem do modelo do personagem (para garantir que vá para frente)
		# Se o tiro sair de lado, mude para: visual_model.global_rotation
		b.global_rotation = visual_model.global_rotation 
	else:
		print("Erro: Muzzle não encontrado!")
