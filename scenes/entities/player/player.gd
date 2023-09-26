extends Entity
@export var sneak = 0.4
@export var sprint = 2

var sneaking: bool = false
var sprinting: bool = false

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
	
	move_in_dir(x_direction, y_direction, current_speed)
