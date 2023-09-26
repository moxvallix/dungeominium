class_name Enemy
extends Entity

@onready var navigation: NavigationAgent2D = %NavigationAgent2D

@export var target: Entity
@export var target_coords: Vector2
@export var navigation_delay: int = 10
@export var slowdown_range: float = 20.0
@export var minimum_distance: float = 18.0

var last_target_pos: Vector2
var last_pos: Vector2
var navigation_path: PackedVector2Array
var navigation_time: int = 0
var random_offset: Vector2 = Vector2.ZERO
var navigation_finished: bool = false

func _ready():
	navigation.connect(&"navigation_finished", _on_navigation_finished)
	pass

func _process(delta) -> void:
	var target_pos: Vector2
	if target:
		target_pos = target.position
	if target_coords:
		target_pos = target_coords
	
	if not target_pos or not navigation: return
	
	if not (target_pos == last_target_pos):
		navigation_time -= 1
	
	if navigation_time <= 0:
		if not in_range_of_target():
			navigation_finished = false
			random_offset = Vector2(
				_random_offset(),
				_random_offset()
			)
		navigation.set_target_position(target_pos + random_offset)
		navigation_time = navigation_delay
		
	if navigation_finished: return
	
	var dir: Vector2 = (navigation.get_next_path_position() - position).normalized()
	if dir: move_in_dir(dir.x, dir.y, get_move_speed())

func in_range_of_target() -> bool: return (navigation.distance_to_target() <= slowdown_range)

func get_move_speed() -> float:
	if in_range_of_target():
		return speed / 2
	else:
		return speed

func _on_navigation_finished():
	navigation_finished = true

func _random_offset() -> float:
	if slowdown_range <= minimum_distance:
		return minimum_distance
	return randf_range(minimum_distance, slowdown_range) * (1 - (2 * randi_range(0, 1)))
