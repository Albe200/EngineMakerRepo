extends CharacterBody3D


const SPEED = 7.0    #By default: 5.0
const JUMP_VELOCITY = 7.0   #By default: 4.5
var respawnPosition = Vector3(0, 3, 0)
@export var mouse_sensitivity_horizontal = 0.2
@export var mouse_sensitivity_vertical = 0.2
@onready var animation =  $gobot/AnimationPlayer    #Getting the reference of the animation node

func _ready() -> void:
	
	#To remove the cursor when game has started
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	animate_player()    #Made by myself for animate player movement
	
	#To make visible the cursor when "Escape" is pressed
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#Check if y-position of player is below -10m so it has to respawn
	if position.y < -4:
		respawn_player()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():    #For jump (see Input map on Project Settings)
		velocity.y = JUMP_VELOCITY
		animation.play("Jump", 0.5)

	# Get the input direction and handle the movement/deceleration
	# As good practice, you should replace UI actions with custom gameplay actions
	var input_dir := Input.get_vector("left", "right", "forward", "backward")    #For move
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func respawn_player():
	position = respawnPosition    #resets the player's position (to its original one from the main scene)

func _input(event):
	if event is InputEventMouseMotion:    #Checks if the mouse is moving
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:    #Checks if the cursor is hiding
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_horizontal))    #Modify this if you want to rotate only the camera, or this plus the player.
			$CameraArm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_vertical))
			
			#Limit the rotation of the camera be upside down with respect to the player, or below the platforms
			$CameraArm.rotation.x = clamp($CameraArm.rotation.x, deg_to_rad(-45.0), deg_to_rad(30.0))

func is_moving():
	return abs(velocity.z) > 0 || abs(velocity.x) > 0    #Checks if playes is moving wether axis z or x

func animate_player():
	if is_on_floor():
		if is_moving():
			animation.play("Run", 0.5)
		else:
			animation.play("Idle", 0.5)
	elif velocity.y < 0:
		animation.play("Fall", 0.1)

#The func _ready() is only called one time when the game gets started (or this scene is acceses for the 1st time)
#The func _physics_process() is called aproximately 60 times per second (or for every frame)
