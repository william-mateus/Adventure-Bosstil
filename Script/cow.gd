extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_cow: AudioStreamPlayer3D = $Audio_Cow

func _ready() -> void:
	# --- Lógica da Animação ---
	var anim = animation_player.get_animation("Eating")
	if anim:
		anim.loop_mode = Animation.LOOP_LINEAR
		animation_player.play("Eating")
		animation_player.advance(randf_range(0, anim.length))
	
	# --- Lógica do Som Aleatório ---
	iniciar_timer_mugido()

func iniciar_timer_mugido() -> void:
	# Criamos um timer via código para não precisar configurar no editor
	var timer = Timer.new()
	add_child(timer)
	
	# Conectamos o fim do tempo à função que toca o som
	timer.timeout.connect(_ao_timer_timeout)
	
	# Define um tempo aleatório para o primeiro mugido (ex: entre 5 e 15 segundos)
	timer.wait_time = randf_range(5.0, 15.0)
	timer.one_shot = true # Ele toca uma vez e vamos reiniciar manualmente
	timer.start()

func _ao_timer_timeout() -> void:
	# Toca o som se ele não estiver tocando
	if not audio_cow.playing:
		# Leve variação de pitch para cada mugido soar único
		audio_cow.pitch_scale = randf_range(0.9, 1.1)
		audio_cow.play()
	
	# Reinicia o timer com um novo tempo aleatório para o próximo mugido
	get_child(get_child_count() - 1).wait_time = randf_range(10.0, 30.0)
	get_child(get_child_count() - 1).start()
