# Nome do Arquivo: enemie3.gd

extends CharacterBody2D

@onready var animador = $AnimatedSprite2D 

func _ready():
	# Inicia a animação de andar.
	animador.play("walk") 
	
func _physics_process(delta):
	# Lógica de movimento (só roda se não for desativado em morrer())
	pass 

# --- FUNÇÃO DE MORTE (CHAMADA PELO LEVEL_1.GD) ---
func morrer():
	# 1. Para o processamento
	set_physics_process(false) 
	
	# 2. Toca a animação de morte
	animador.play("death") 
	
	# 3. Desativa a colisão
	if is_instance_valid($CollisionShape2D):
		$CollisionShape2D.set_deferred("disabled", true) 

	# Desaparece o inimigo
	queue_free()
