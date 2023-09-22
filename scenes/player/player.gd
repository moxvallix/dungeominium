extends CharacterBody2D
@export var speed = 100.0
@export var sneak = 0.4
@export var sprint = 2

var sneaking: bool = false
var sprinting: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if Input.is_action_pressed("player_sneak"):
		sneaking = true
	elif Input.is_action_pressed("player_sprint"):
		sprinting = true
	else:
		sneaking = false
		sprinting = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var current_speed = speed
	if sneaking:
		current_speed *= sneak
	if sprinting:
		current_speed *= sprint
	
	var x_direction = Input.get_axis("player_left", "player_right")
	var y_direction = Input.get_axis("player_up", "player_down")
	if x_direction:
		velocity.x = x_direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	if y_direction:
		velocity.y = y_direction * current_speed
	else:
		velocity.y = move_toward(velocity.y, 0, current_speed)

	move_and_slide()
