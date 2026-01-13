extends MeshInstance3D

const rotationalSpeed = 0.3
var es_rotable_en_x = false
var es_rotable_en_z = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rotation.x != 0:    #Aply rotation for originally rotated bridges on axis X on Escena3D
		if deg_to_rad(rotation.y) == deg_to_rad(0):
			es_rotable_en_x = true
		elif rotation.y >= 1.57 and rotation.y <= 1.58:
			es_rotable_en_z = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if es_rotable_en_x:
		rotate_x(deg_to_rad(rotationalSpeed))
	if es_rotable_en_z:
		rotate_z(deg_to_rad(rotationalSpeed))
