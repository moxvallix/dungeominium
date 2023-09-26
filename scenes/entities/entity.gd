class_name Entity
extends CharacterBody2D

signal position_updated
signal health_changed

@export var health: int
@export var speed: float = 100.0

func move_in_dir(x, y, move_speed = null):
	if move_speed == null: move_speed = speed
	if x and x != 0:
		velocity.x = x * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	if y and y != 0:
		velocity.y = y * move_speed
	else:
		velocity.y = move_toward(velocity.y, 0, move_speed)
	move_and_slide()
	
	if (x or y) and move_speed > 0:
		emit_signal(&"position_updated", position)
