extends Area3D

var rotationalSpeed = 1.25
var es_rotable_en_x = false
var es_rotable_en_y = false
var es_rotable_en_z = false
const rotationalIncreasePercent = 0.66

@export var push_force: float = 6.0
@export var radial_force: float = 4.0
@export var vertical_force: float = 3.0
@export var stun_duration: float = 0.2
@export var rotation_speed_multiplier: float = 0.8

func _ready() -> void:
	monitoring = true
	monitorable = true
	
	for child in get_children():
		if child is CollisionShape3D:
			child.scale = Vector3(1.15, 1.15, 1.15)
	
	if rotation.z == 0:
		es_rotable_en_y = true
	else:
		rotationalSpeed += rotationalSpeed * rotationalIncreasePercent
		if rotation.y == 0:
			es_rotable_en_x = true
		else:
			es_rotable_en_z = true

func _process(delta: float) -> void:
	if es_rotable_en_y:
		rotate_y(deg_to_rad(rotationalSpeed))
	elif es_rotable_en_x:
		rotate_x(deg_to_rad(rotationalSpeed))
	elif es_rotable_en_z:
		rotate_z(deg_to_rad(rotationalSpeed))

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		apply_push_back(body)

func apply_push_back(player: CharacterBody3D) -> void:
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	
	if distance < 0.001:
		return
	
	var radial_dir = to_player / distance
	
	var tangential_dir: Vector3
	
	# EMPUJE EN LA MISMA DIRECCIÓN DE LA ROTACIÓN
	if es_rotable_en_y:
		tangential_dir = Vector3(radial_dir.z, 0, -radial_dir.x)
	elif es_rotable_en_x:
		tangential_dir = Vector3(0, radial_dir.z, -radial_dir.y)
	elif es_rotable_en_z:
		tangential_dir = Vector3(radial_dir.y, -radial_dir.x, 0)
	
	var dynamic_mult = 1.0 + (rotationalSpeed * rotation_speed_multiplier / 10.0)
	var final_tangential = push_force * dynamic_mult
	var final_radial = radial_force * dynamic_mult
	
	var push_vector = Vector3(
		(tangential_dir.x * final_tangential) + (radial_dir.x * final_radial),
		(tangential_dir.y * final_tangential) + (radial_dir.y * final_radial) + vertical_force,
		(tangential_dir.z * final_tangential) + (radial_dir.z * final_radial)
	)
	
	if player.has_method("apply_knockback"):
		player.apply_knockback(push_vector, stun_duration)
	else:
		player.velocity = push_vector
