extends Control

@onready var coinsLabel = $CoinsLabel    #"onready" waits all to be initialized to create the var(good practice)"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coinsLabel.text = "x %d" %GameManager.score
