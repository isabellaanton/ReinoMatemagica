extends Node2D

# ⚠️ PASSO CRUCIAL: Mude $enemie1 para o nome real do seu nó inimigo, se for diferente.
@onready var enemy_node = $enemie1

# Labels e Botões
@onready var conta_label 	= $conta_label
@onready var feedback_label = $FeedbackLabel 

@onready var botao1 = $GridContainer/Button
@onready var botao2 = $GridContainer/Button2
@onready var botao3 = $GridContainer/Button3
@onready var botao4 = $GridContainer/Button4

# Corações
@onready var heart1 = $CanvasLayer2/HeartHolder/HeartContainer/Heart1
@onready var heart2 = $CanvasLayer2/HeartHolder/HeartContainer/Heart2
@onready var heart3 = $CanvasLayer2/HeartHolder/HeartContainer/Heart3

# Variáveis de Estado
var resposta_certa: int = 0
var rng := RandomNumberGenerator.new()
var vidas: int = 3
var nivel_atual: int = 1 


func _ready():
	rng.randomize()
	
	if not is_instance_valid(conta_label) or not is_instance_valid(feedback_label):
		push_error("ERRO FATAL: Verifique os caminhos @onready.")
		return
		
	gerar_nova_conta()
	feedback_label.text = "Nível %d: Adição" % nivel_atual
	atualizar_vidas_ui()


# --- LÓGICA DO LEVEL 1: ADIÇÃO ---
func gerar_nova_conta():
	feedback_label.text = ""
	
	var a = rng.randi_range(0, 9)
	var b = rng.randi_range(0, 9)
	resposta_certa = a + b
	conta_label.text = "%d + %d = ?" % [a, b]
	
	gerar_opcoes()


func gerar_opcoes():
	var opcoes: Array = []
	opcoes.append(resposta_certa)
	while opcoes.size() < 4:
		var fake = resposta_certa + rng.randi_range(-5, 5)
		if fake >= 0 and fake != resposta_certa and fake not in opcoes:
			opcoes.append(fake)
	opcoes.shuffle()

	var padding = "  " # Use espaço normal, não espaço não-quebrável ( )
	botao1.text = padding + str(opcoes[0]) + padding
	botao2.text = padding + str(opcoes[1]) + padding
	botao3.text = padding + str(opcoes[2]) + padding
	botao4.text = padding + str(opcoes[3]) + padding


func verificar_resposta(botao: Button):
	if vidas <= 0:
		return

	# ✅ CORREÇÃO CRUCIAL: Remove espaços em branco do texto antes de converter para número.
	var valor_string = botao.text.strip_edges()
	var valor = valor_string.to_int() 

	if valor == resposta_certa:
		feedback_label.text = "Parabéns! Resposta correta! 🎉"
		await get_tree().create_timer(0.7).timeout
		
		# ✅ CHAMA O DESAPARECIMENTO IMEDIATO
		avancar_nivel() 
			
	else:
		vidas -= 1
		atualizar_vidas_ui()

		if vidas > 0:
			feedback_label.text = "Ops... tente novamente!"
		else:
			feedback_label.text = "💀 Você perdeu todas as vidas!"
			game_over()


# --- FUNÇÕES DE MORTE E TRANSIÇÃO ---
func avancar_nivel():
	derrotar_inimigo()

func derrotar_inimigo():
	# 1. MORTE DO INIMIGO (Chama a função morrer que faz o queue_free() imediato no enemie1.gd)
	if is_instance_valid(enemy_node) and enemy_node.has_method("morrer"):
		enemy_node.morrer()	
		
	# 2. ESCONDER OS BOTÕES E CONTA (Desaparecimento imediato dos botões)
	conta_label.visible = false
	botao1.visible = false
	botao2.visible = false
	botao3.visible = false
	botao4.visible = false
	
	feedback_label.text = "Nível Concluído! Passando para o próximo..."

	# ⚠️ Timer de espera removido!

	# 3. TRANSIÇÃO DE NÍVEL
	nivel_atual += 1
	# Ex: get_tree().change_scene_to_file("res://caminho/para/level_2.tscn")


func atualizar_vidas_ui():
	if is_instance_valid(heart1):
		heart1.visible = vidas >= 1
	if is_instance_valid(heart2):
		heart2.visible = vidas >= 2
	if is_instance_valid(heart3):
		heart3.visible = vidas >= 3


func game_over():
	botao1.disabled = true
	botao2.disabled = true
	botao3.disabled = true
	botao4.disabled = true

	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene() 


# --- CONEXÕES DOS BOTÕES ---
func _on_button_pressed() -> void:
	verificar_resposta(botao1)

func _on_button_2_pressed() -> void:
	verificar_resposta(botao2)

func _on_button_3_pressed() -> void:
	verificar_resposta(botao3)

func _on_button_4_pressed() -> void:
	verificar_resposta(botao4)

# --- CONEXÕES DE PAUSA ---
func _on_pausar_pressed() -> void:
	get_tree().paused = true


func _on_despausar_pressed() -> void:
	get_tree().paused = false
