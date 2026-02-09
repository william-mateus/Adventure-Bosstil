extends Node3D

@export var enemy_scene : PackedScene
@export var spawn_radius : float = 30.0 
@export var base_spawn_rate : float = 2.0
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var wave_atual : int = 1
var wave_maxima : int = 5
var inimigos_para_spawnar : int = 0
var inimigos_gerados_nesta_wave : int = 0
var timer = 0.0
var wave_em_andamento : bool = false

func _ready():
	# Aguarda um segundo antes de começar a primeira onda
	await get_tree().create_timer(1.0).timeout
	preparar_onda(wave_atual)

func _process(delta):
	if not wave_em_andamento:
		return

	# Fase 1: Spawning (Gerando inimigos)
	if inimigos_gerados_nesta_wave < inimigos_para_spawnar:
		timer += delta
		if timer >= base_spawn_rate:
			spawn_enemy()
			timer = 0.0
	else:
		# Fase 2: Monitoramento (Esperando todos morrerem)
		verificar_fim_da_onda()

func preparar_onda(numero):
	wave_atual = numero
	inimigos_gerados_nesta_wave = 0
	inimigos_para_spawnar = numero * 5
	wave_em_andamento = true
	print("--- ONDA ", wave_atual, " COMEÇOU! (Total: ", inimigos_para_spawnar, ") ---")

func spawn_enemy():
	if not enemy_scene: return
	
	var enemy = enemy_scene.instantiate()
	
	# Posição de spawn
	var angle = randf() * PI * 2
	var pos = Vector3(cos(angle) * spawn_radius, 0, sin(angle) * spawn_radius)
	
	# Lógica da cerca
	var cercas = get_tree().get_nodes_in_group("cercas")
	if cercas.size() > 0:
		var cerca_proxima = cercas[0]
		var menor_dist = pos.distance_to(cerca_proxima.global_position)
		for c in cercas:
			var d = pos.distance_to(c.global_position)
			if d < menor_dist:
				menor_dist = d
				cerca_proxima = c
		enemy.posicao_cerca = cerca_proxima.global_position

	# ADICIONA O INIMIGO E CONFIGURA O GRUPO
	add_child(enemy)
	enemy.global_position = pos
	enemy.add_to_group("inimigos_vivos") # ESSENCIAL
	
	inimigos_gerados_nesta_wave += 1
	print("Inimigo spawnado (", inimigos_gerados_nesta_wave, "/", inimigos_para_spawnar, ")")

func verificar_fim_da_onda():
	var vivos = get_tree().get_nodes_in_group("inimigos_vivos").size()
	
	# Otimização: Só printa se ainda tiver inimigos, para não inundar o console
	if vivos == 0:
		print("--- ONDA ", wave_atual, " LIMPA! ---")
		wave_em_andamento = false
		
		if wave_atual < wave_maxima:
			print("Próxima onda em 3 segundos...")
			await get_tree().create_timer(3.0).timeout
			preparar_onda(wave_atual + 1)
		else:
			print("VITÓRIA FINAL! Todas as ondas concluídas.")
