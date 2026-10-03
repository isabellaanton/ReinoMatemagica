extends Control

# Nomes dos botões no seu menu de transição
@onready var prox_nivel_button = $ProxNivel
@onready var reiniciar_button = $Reiniciar
@onready var sair_button = $Sair


func _ready():
	# Conectar sinais dos botões
	if is_instance_valid(prox_nivel_button):
		prox_nivel_button.pressed.connect(_on_proximo_nivel_pressed)
	if is_instance_valid(reiniciar_button):
		reiniciar_button.pressed.connect(_on_reiniciar_pressed)
	if is_instance_valid(sair_button):
		sair_button.pressed.connect(_on_sair_pressed)


# -------------------------------
# BOTÃO 1 → PRÓXIMO NÍVEL
# -------------------------------
func _on_proximo_nivel_pressed():
	# ✅ CORREÇÃO: Leva para o Level 4
	get_tree().change_scene_to_file("res://level_4.tscn") 


# -------------------------------
# BOTÃO 2 → REINICIAR (voltar ao menu)
# -------------------------------
func _on_reiniciar_pressed():
	# Assumindo que o MainMenu se chama MainMenu.tscn
	get_tree().change_scene_to_file("res://MainMenu.tscn") 


# -------------------------------
# BOTÃO 3 → SAIR
# -------------------------------
func _on_sair_pressed():
	get_tree().quit()


func _on_prox_nivel_pressed() -> void:
	pass # Replace with function body.
