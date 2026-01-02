extends Node3D

var score = 0    #Total of coins collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_score():    #It's called through the Coin (its script) when player collisioned
	score += 1
