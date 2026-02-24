extends CharacterBody3D

const SPEED = 6.5
const JUMP_VELOCITY = 8
const friction = 15.0
const acceleration = 25.0

var jumped_twice = false
var respawnPosition = Vector3(0, 2, 0)
var knockback_timer: float = 0.0  # Temporizador de stun/empuje

@export var mouse_sensitivity_horizontal = 0.2
@export var mouse_sensitivity_vertical = 0.2

@onready var animation = $gobot/AnimationPlayer
@onready var jumpAudio = $JumpAudio
@onready var walkingAudio = $WalkingAudio
@onready var pause_menu := $CanvasLayer/MenuPausa

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# PRIORIDAD 1: Knockback/empuje - sin controles del jugador
	if knockback_timer > 0:
		knockback_timer -= delta
		# Aplicar gravedad durante knockback
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	# Resto del código normal...
	animate_player()
	
	# Pausa
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		toggle_pause()
	
	# Respawn
	if position.y < -4:
		respawn_player()
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("Jump", 0.5)
		jumpAudio.play()
	
	# Doble salto
	if Input.is_action_just_pressed("jump") and not is_on_floor() and not jumped_twice:
		velocity.y = JUMP_VELOCITY * 0.75
		animation.play("Flip", 0.3)
		jumpAudio.play()
		jumped_twice = true
	
	if is_on_floor() and jumped_twice:
		jumped_twice = false
	
	# Movimiento normal
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
	
	move_and_slide()

func respawn_player():
	position = respawnPosition
	velocity = Vector3.ZERO
	knockback_timer = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_horizontal))
			$CameraArm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_vertical))
			$CameraArm.rotation.x = clamp($CameraArm.rotation.x, deg_to_rad(-45.0), deg_to_rad(30.0))

func is_moving():
	return abs(velocity.z) > 0.1 || abs(velocity.x) > 0.1

func animate_player():
	if is_on_floor():
		if is_moving():
			animation.play("Run", 0.5)
			walkingAudio.stream_paused = false
		else:
			animation.play("Idle", 0.5)
			walkingAudio.stream_paused = true
	elif velocity.y < 0:
		animation.play("Fall", 0.1)
	else:
		walkingAudio.stream_paused = true

func update_respawn(newRespawn: Vector3):
	respawnPosition = newRespawn

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.hide()
	else:
		get_tree().paused = true
		pause_menu.show()

# FUNCIÓN DE KNOCKBACK - Llamada por los obstáculos
func apply_knockback(push_vector: Vector3, duration: float = 0.3) -> void:
	# Limitar velocidad máxima de knockback para evitar bugs
	var max_speed = 25.0
	if push_vector.length() > max_speed:
		push_vector = push_vector.normalized() * max_speed
	
	velocity = push_vector
	knockback_timer = duration
	print(">>> KNOCKBACK APLICADO: ", push_vector, " | Duración: ", duration)
