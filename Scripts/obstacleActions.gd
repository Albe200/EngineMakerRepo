extends Area3D

var rotationalSpeed = 3.5
var es_rotable_en_x = false
var es_rotable_en_y = false
var es_rotable_en_z = false
const rotationalIncreasePercent = 0.66

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rotation.z == 0:    #If the obstacle is on a platform
		es_rotable_en_y = true
	else:
		rotationalSpeed += rotationalSpeed * rotationalIncreasePercent
		if rotation.y == 0:    #When the platform is floating
			es_rotable_en_x = true
		else:
			es_rotable_en_z = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if es_rotable_en_y:
		rotate_y(deg_to_rad(rotationalSpeed))
	elif es_rotable_en_x:
		rotate_x(deg_to_rad(rotationalSpeed))
	elif es_rotable_en_z:
		rotate_z(deg_to_rad(rotationalSpeed))
