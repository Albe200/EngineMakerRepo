extends MeshInstance3D

const rotationalSpeed = 0.3
var es_rotable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rotation.x == 0:
		es_rotable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if es_rotable:
		rotate_z(deg_to_rad(rotationalSpeed))
