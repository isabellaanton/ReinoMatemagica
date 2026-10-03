extends CharacterBody2D

@onready var anim = $AnimatedSprite2D2

const SPEED = 200
const JUMP_FORCE = -450
const GRAVITY = 1100

func _physics_process(delta):
	# Aplicando gravidade
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Movimentação esquerda/direita
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	# Virar sprite dependendo da direção
	if direction != 0:
		anim.flip_h = (direction < 0)

	# Pular
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE
		play_animation("pular")
	else:
		# Definindo animações automáticas
		if not is_on_floor():
			play_animation("pular")
		elif direction != 0:
			play_animation("run")
		else:
			play_animation("andar")

	move_and_slide()


func play_animation(animation_name: String):
	if anim.animation != animation_name:
		anim.play(animation_name)
