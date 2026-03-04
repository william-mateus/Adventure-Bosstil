extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		animation_player.play("fade_in")
		
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Preferbs/menuFull.tscn")
