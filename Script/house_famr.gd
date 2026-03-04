extends Node3D

# Referência direta ao seu novo nó com Nome Único
@onready var area_detector: Area3D = %Area3D_House_Farm
@onready var life_bar: ProgressBar = %Life_ProgressBar 

@export var max_health: int = 100
var current_health: int = 100

func _ready() -> void:
	current_health = max_health
	if life_bar:
		life_bar.max_value = max_health
		life_bar.value = current_health
	
	# Conexão robusta: usamos a variável @onready diretamente
	if area_detector:
		area_detector.body_entered.connect(_on_enemy_entered)
		print("Sucesso: Area3D_House_Farm conectada via Nome Único!")
	else:
		push_error("ERRO: Não consegui encontrar o nó %Area3D_House_Farm!")

func _on_enemy_entered(body: Node3D):
	
	if body.is_in_group("inimigos_vivos"):
		# Reduzi o tempo para 0.05s apenas para garantir que a colisão física 
		# seja registrada antes do objeto ser deletado, evitando o 'morte no ar'
		await get_tree().create_timer(0.05).timeout
		
		# Verifica se o inimigo ainda existe após o micro-delay
		if is_instance_valid(body):
			print("Inimigo detectado na Area3D_House_Farm!")
			take_damage(5)
			
			if body.has_method("morrer_inimigo"):
				body.morrer_inimigo()

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	if life_bar:
		life_bar.value = current_health
	
	if current_health <= 0:
		handle_game_over()

func handle_game_over():
	print("GAME OVER - A casa caiu!")
