extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	
	var anim = animation_player.get_animation("Animation")
	
	if anim:
		
		anim.loop_mode = Animation.LOOP_LINEAR
		
		animation_player.play("Animation")
	else:
		print("Não achei a animação")
