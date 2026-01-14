extends Control

@onready var bar := $ProgressBar
@onready var play := $Button
@export var game_scene:PackedScene   # aparecerá en el Inspector

var filling := false
var elapsed_time := 0.0
const elapsed_time_max := 10.0

func _ready():
	bar.max_value = 100
	bar.value = 0
	play.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	if not filling:
		filling = true
	else:
		filling = false
	#play.disabled = true    #Para evitar el doble click

func _process(_delta):
	if filling:
		play.text = "CANCELAR"
		if bar.value < 100:
			if (bar.value == 25.0 or bar.value == 50.0 or bar.value == 75.0) and elapsed_time < elapsed_time_max:
				elapsed_time += 0.05
			else:
				bar.value += 0.2 + elapsed_time
				elapsed_time = 0.0
		else:
			filling = false
			print("Cambiando a juego...")
			get_tree().change_scene_to_packed(game_scene)    # Cambio de escena clásico (Godot 4)
	else:
		play.text = "PLAY GAME"
		bar.value = 0
		elapsed_time = 0
