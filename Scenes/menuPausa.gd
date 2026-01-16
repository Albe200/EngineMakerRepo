extends Control

@onready var cont := $VBoxContainer/Button
@onready var quit := $VBoxContainer/Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cont.pressed.connect(_on_continue)
	quit.pressed.connect(_on_quit)

func _on_continue():
	get_tree().paused = false   # descongela
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()

func _on_quit():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
