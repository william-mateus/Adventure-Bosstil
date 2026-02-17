extends Node3D

@export var max_health: int = 100
var current_health: int = 100

@onready var life_bar: ProgressBar = %Life_ProgressBar 

func _ready() -> void:
	current_health = max_health
	if life_bar:
		life_bar.max_value = max_health
		life_bar.value = current_health
	
	# Esta linha é a mágica: ela procura a Area3D mesmo que esteja dentro de cubos
	var area_detectora = find_child("Area3D")
	
	if area_detectora:
		area_detectora.body_entered.connect(_on_enemy_entered)
		print("Sucesso: Área de dano conectada!")
	else:
		# Se você renomeou para 'AreaDano', mude o nome no find_child acima
		push_error("ERRO: Não encontrei nenhum nó Area3D dentro da casa!")

func _on_enemy_entered(body: Node3D):
	if body.is_in_group("inimigos_vivos"):
		# Espera 0.5 segundos antes de processar o dano 
		# Só para você conseguir ver o inimigo aparecendo
		await get_tree().create_timer(0.5).timeout
		
		if is_instance_valid(body): # Verifica se o inimigo ainda existe
			take_damage(5)
			if body.has_method("morrer_inimigo"):
				body.morrer_inimigo()

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	if life_bar:
		life_bar.value = current_health
	
	if current_health <= 0:
		print("GAME OVER")
