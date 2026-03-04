extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	
	var anim = animation_player.get_animation("mixamo_com")
	
	if anim:
		
		anim.loop_mode = Animation.LOOP_LINEAR
		
		animation_player.play("mixamo_com")
	else:
		print("Não achei a animação")
