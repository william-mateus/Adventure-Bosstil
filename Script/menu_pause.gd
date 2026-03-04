extends CanvasLayer

@onready var resume: Button = $backgroundOver/menu_holder/Resume
@onready var quit: Button = $backgroundOver/menu_holder/Quit
@onready var animator: AnimationPlayer = $animator


func _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		animator.play("pause_game")
		get_tree().paused = true
		resume.grab_focus()


func _on_resume_pressed() -> void:
	animator.play("resume_game")
	get_tree().paused = false
	await animator.animation_finished
	visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()
