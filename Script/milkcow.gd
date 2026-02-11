extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	# --- Lógica da Animação ---
	var anim = animation_player.get_animation("Animation")
	
	if anim:
		# 1. Configura o loop
		anim.loop_mode = Animation.LOOP_LINEAR
		
		# 2. Dá o play na animação
		animation_player.play("Animation")
		
		# 3. Pula para um ponto aleatório para não sincronizar com as outras
		animation_player.advance(randf_range(0.0, anim.length))
	else:
		print("Não achei a animação: Animation")

	# --- Lógica do Som (Mugido) ---
	iniciar_timer_mugido()

func iniciar_timer_mugido() -> void:
	# Criamos um timer para controlar o intervalo entre os mugidos
	var timer = Timer.new()
	add_child(timer)
	
	# Conecta o sinal de término do tempo à função de mugir
	timer.timeout.connect(_ao_timer_timeout)
	
	# Define um tempo aleatório para o primeiro mugido (ex: entre 7 e 20 segundos)
	timer.wait_time = randf_range(7.0, 20.0)
	timer.one_shot = true 
	timer.start()

func _ao_timer_timeout() -> void:
	# Só toca se o som não estiver sendo reproduzido no momento
	if not audio_stream_player_3d.playing:
		# Muda levemente o tom (pitch) para cada vaca parecer ter uma voz diferente
		audio_stream_player_3d.pitch_scale = randf_range(0.85, 1.15)
		audio_stream_player_3d.play()
	
	# Reinicia o timer com um novo tempo aleatório para o próximo mugido
	var timer = get_child(get_child_count() - 1) as Timer
	timer.wait_time = randf_range(15.0, 40.0)
	timer.start()
