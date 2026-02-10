extends CharacterBody3D

var speed = 2.0
var health = 1
var posicao_cerca : Vector3
var morreu := false
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _physics_process(delta):
	if morreu:
		return

	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()

	velocity = direction * speed
	move_and_slide()

	atualizar_animacao()

	
func  _ready() -> void:
	navigation_agent_3d.target_position = posicao_cerca

func atualizar_animacao():
	if velocity.length() > 0.1:
		trocar_animacao("Armature|Running")
	else:
		trocar_animacao("Armature|Idle_talking")

func trocar_animacao(nome: String):
	if animation_player.current_animation != nome:
		animation_player.play(nome)


func take_damage(amount):
	if morreu:
		return

	print("Inimigo atingido!")  
	health -= amount

	if health <= 0:
		morreu = true
		remove_from_group("inimigos_vivos")
		queue_free()


func _on_navigation_agent_3d_target_reached() -> void:
	if morreu:
		return

	morreu = true
	velocity = Vector3.ZERO
	navigation_agent_3d.target_position = global_position

	animation_player.play("Armature|Mortal")

	
