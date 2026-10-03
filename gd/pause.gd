extends TextureButton

@export var texture_pause : Texture2D
@export var texture_play : Texture2D

var is_paused := false

func _ready():
	self.pressed.connect(_toggle_pause)
	texture_normal = texture_pause
	pause_mode = Node.PAUSE_MODE_PROCESS   # botão continua funcionando no pause


func _toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused

	if is_paused:
		texture_normal = texture_play
	else:
		texture_normal = texture_pause
