# Nome do Arquivo: enemie1.gd

extends CharacterBody2D

@onready var animador = $AnimatedSprite2D 

func _ready():
	# Inicia a animação de andar.
	animador.play("walk") 
	
func _physics_process(delta):
	# Lógica de movimento (apenas se a animação não for death)
	if animador.animation != "death":
		# ⚠️ COLOQUE SEU CÓDIGO DE MOVIMENTO AQUI
		pass 

# --- FUNÇÃO DE MORTE (CHAMADA PELO LEVEL_1.GD) ---
func morrer():
	# 1. Para o processamento
	set_physics_process(false) 
	
	# 2. Toca a animação de morte (se houver tempo)
	animador.play("death") 
	
	# 3. Desativa a colisão
	if is_instance_valid($CollisionShape2D):
		$CollisionShape2D.set_deferred("disabled", true) 

	# ✅ ESTE COMANDO REMOVE O NÓ IMEDIATAMENTE (desaparecer)
	queue_free()

# ⚠️ REMOVA A FUNÇÃO _on_animated_sprite_2d_animation_finished() 
# do seu script enemie1.gd, pois ela não é mais necessária.
