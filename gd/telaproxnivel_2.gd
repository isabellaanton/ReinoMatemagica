extends Control

#proxnivel multi --> div
func _ready():
	# Conectar sinais dos botões
	$ProxNivel.pressed.connect(_on_proximo_nivel_pressed)
	$Reiniciar.pressed.connect(_on_reiniciar_pressed)
	$Sair.pressed.connect(_on_sair_pressed)


# -------------------------------
#  BOTÃO 1 → PRÓXIMO NÍVEL
# -------------------------------
func _on_proximo_nivel_pressed():
	get_tree().change_scene_to_file("res://level_3.tscn")


# -------------------------------
#  BOTÃO 2 → REINICIAR (voltar ao menu)
# -------------------------------
func _on_reiniciar_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")


# -------------------------------
#  BOTÃO 3 → SAIR
# -------------------------------
func _on_sair_pressed():
	get_tree().quit()
