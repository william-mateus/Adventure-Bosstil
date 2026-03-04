extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		animation.play("fade_in")
		
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Preferbs/splash_screen.tscn")
