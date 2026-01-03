extends Area3D

const ROTATION_SPEED = 3;    #Setting a constant value for the rotational speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":    #Checks if the body collisiones is the player
		GameManager.add_score()
		AudioManager.coinAudio.play()
		queue_free()
