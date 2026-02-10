extends Node3D

@export var enemy_scene : PackedScene
@export var spawn_radius : float = 30.0 
@export var base_spawn_rate : float = 2.0

# Referências da UI (Arraste os nós para aqui se os nomes forem diferentes)
@onready var wave_label = %WaveLabel
@onready var enemies_label = %EnemiesLabel

var wave_atual : int = 1
var wave_maxima : int = 5
var inimigos_para_spawnar : int = 0
var inimigos_gerados_nesta_wave : int = 0
var timer = 0.0
var wave_em_andamento : bool = false

func _ready():
	await get_tree().create_timer(1.0).timeout
	preparar_onda(wave_atual)

func _process(delta):
	# Atualiza a contagem de inimigos na tela todo frame
	atualizar_ui()

	if not wave_em_andamento:
		return

	if inimigos_gerados_nesta_wave < inimigos_para_spawnar:
		timer += delta
		if timer >= base_spawn_rate:
			spawn_enemy()
			timer = 0.0
	else:
		verificar_fim_da_onda()

func atualizar_ui():
	var vivos = get_tree().get_nodes_in_group("inimigos_vivos").size()
	
	# Atualiza os textos
	wave_label.text = "ONDA: " + str(wave_atual) + " / " + str(wave_maxima)
	
	if wave_em_andamento:
		enemies_label.text = "INIMIGOS RESTANTES: " + str(vivos)
	else:
		enemies_label.text = "PREPARE-SE PARA A PRÓXIMA!"

func preparar_onda(numero):
	wave_atual = numero
	inimigos_gerados_nesta_wave = 0
	inimigos_para_spawnar = numero * 5
	wave_em_andamento = true

func spawn_enemy():
	if not enemy_scene: return
	
	var enemy = enemy_scene.instantiate()
	
	# Posição e Lógica da Cerca
	var angle = randf() * PI * 2
	var pos = Vector3(cos(angle) * spawn_radius, 0, sin(angle) * spawn_radius)
	
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

	add_child(enemy)
	enemy.global_position = pos
	enemy.add_to_group("inimigos_vivos")
	
	inimigos_gerados_nesta_wave += 1

func verificar_fim_da_onda():
	var vivos = get_tree().get_nodes_in_group("inimigos_vivos").size()
	
	if vivos == 0:
		wave_em_andamento = false
		
		if wave_atual < wave_maxima:
			await get_tree().create_timer(4.0).timeout 
			preparar_onda(wave_atual + 1)
		else:
			wave_label.text = "VITÓRIA!"
			enemies_label.text = "VOCÊ SOBREVIVEU!"
			set_process(false)
