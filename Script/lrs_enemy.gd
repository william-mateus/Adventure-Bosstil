extends CharacterBody3D

var speed = 2.0
var health = 1
var posicao_cerca : Vector3
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _physics_process(delta):
	
	var destination = navigation_agent_3d.get_next_path_position()
	var localDestination = destination - global_position
	var direction = localDestination.normalized()
	velocity = direction * speed
	
	move_and_slide()
	
func  _ready() -> void:
	navigation_agent_3d.target_position = posicao_cerca

func take_damage(amount):
	print("Inimigo atingido!")  
	health -= amount
	if health <= 0:
		queue_free() # Inimigo desaparece


func _on_navigation_agent_3d_target_reached() -> void:
	animation_player.play("Armature|Mortal")
	navigation_agent_3d.target_position = Vector3.ZERO
	
