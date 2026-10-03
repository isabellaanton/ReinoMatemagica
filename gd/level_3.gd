extends Node2D

# NOME DOS NÓS
@onready var enemy_node = $enemie3
@onready var portal_node = $portal # ✅ Adicionado o nó do portal

@onready var conta_label 	= $Label
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
var nivel_atual: int = 4 


func _ready():
	rng.randomize()
	
	if not is_instance_valid(conta_label) or not is_instance_valid(feedback_label):
		push_error("ERRO FATAL: Verifique os caminhos @onready.")
		return
		
	# ⚠️ CRUCIAL: O portal deve começar invisível e sem colisão
	if is_instance_valid(portal_node):
		portal_node.visible = false
		# Assumindo que o portal tem um nó de colisão (Area2D ou CollisionShape2D)
		# Se for uma Area2D chamada 'portal', a colisão deve ser desabilitada
		# Ex: portal_node.get_node("CollisionShape2D").disabled = true 

	gerar_nova_conta()
	feedback_label.text = "Nível %d: Divisão" % nivel_atual
	atualizar_vidas_ui()


# --- LÓGICA DO LEVEL 4: DIVISÃO ---
func gerar_nova_conta():
	feedback_label.text = ""
	
	var resultado = rng.randi_range(1, 9) 
	var b = rng.randi_range(1, 9)         
	var a = resultado * b                 
	
	resposta_certa = resultado 
	conta_label.text = "%d ÷ %d = ?" % [a, b] 
	


func gerar_opcoes():
	var opcoes: Array = []
	opcoes.append(resposta_certa)
	while opcoes.size() < 4:
		var fake = resposta_certa + rng.randi_range(-3, 3)
		if fake > 0 and fake != resposta_certa and fake not in opcoes:
			opcoes.append(fake)
	opcoes.shuffle()

	botao1.text = str(opcoes[0])
	botao2.text = str(opcoes[1])
	botao3.text = str(opcoes[2])
	botao4.text = str(opcoes[3])


func verificar_resposta(botao: Button):
	if vidas <= 0:
		return

	var texto_limpo = botao.text.trim_prefix(" ").trim_suffix(" ").strip_edges()
	var valor = texto_limpo.to_int() 

	if valor == resposta_certa:
		feedback_label.text = "Parabéns! Resposta correta! 🎉"
		await get_tree().create_timer(0.7).timeout
		
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
	
	# 1. MORTE DO INIMIGO
	if is_instance_valid(enemy_node) and enemy_node.has_method("morrer"):
		enemy_node.morrer()	
		
	# 2. ESCONDER UI
	conta_label.visible = false
	botao1.visible = false
	botao2.visible = false
	botao3.visible = false
	botao4.visible = false
	
	feedback_label.text = "Portal aberto! Vá até o portal para sair!"

	# 3. HABILITAR O PORTAL (AGORA ELE SÓ APARECE)
	if is_instance_valid(portal_node):
		portal_node.visible = true
		# Habilitar a colisão do portal
		# portal_node.get_node("CollisionShape2D").disabled = false 


# ✅ NOVA FUNÇÃO: CHAMADA PELA COLISÃO DO PORTAL
# Você precisa conectar o sinal 'body_entered' do nó Area2D 'portal' a este script.
func _on_portal_body_entered(body):
	# Assumindo que o corpo que entra é o player.
	if body.name == "Player": # Se o seu Player se chama "Player"
		feedback_label.text = "Carregando próximo nível..."
		
		# Transição para a tela de vitória
		get_tree().change_scene_to_file("res://telaproxnivel3.tscn") 


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
