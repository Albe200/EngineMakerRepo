extends Control

@onready var bar := $ProgressBar
@onready var play := $VBoxContainer/Button    #alternative: @onready var play := vbox.get_node("Button")
@onready var quit := $VBoxContainer/Button2
@export var game_scene:PackedScene   # aparecerá en el Inspector

var filling := false
var elapsed_time := 0.0
const elapsed_time_max := 10.0

func _ready():
	bar.max_value = 100
	bar.value = 0
	bar.hide()
	
	play.pressed.connect(_on_play_pressed)
	quit.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	if not filling:
		filling = true
		bar.show()
	else:
		filling = false
		bar.hide()

func _on_quit_pressed():
	get_tree().quit()

func _process(_delta):
	if filling:
		play.text = "CANCEL"
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
