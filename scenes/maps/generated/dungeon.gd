extends TileMap

@export var width: int = 64
@export var height: int = 64
@export var smoothing: int = 5
@export_range(0, 100, 1) var fill_percent: int = 50
@export var seed: String = "seed"
var map: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		generate_map(str(randi()))

func generate_map(map_seed = seed):
	random_fill_map(map_seed)
	
	for i in smoothing:
		smooth_map()
#
	set_tilemap_from_map()

func random_fill_map(map_seed: String) -> void:
	map.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(map_seed)
	for x in width:
		map.append([])
		for y in height:
			if x == 0 || x == (width - 1) || y == 0 || y == (height - 1):
				map[x].append(1)
			else:
				map[x].append(1 if (rng.randi_range(0, 100) > fill_percent) else 0)

func set_tilemap_from_map() -> void:
	for x in width:
		for y in height:
			var cell = Vector2i(11, 1) if (map[x][y] == 1) else Vector2i(12, 5)
			set_cell(0, Vector2i(x, y), 1, cell)

func smooth_map() -> void:
	var smooth_check: int = 4
	for x in width:
		for y in height:
			var neighbour_count: int = get_surrounding_wall_count(x, y)
			if neighbour_count > smooth_check:
				map[x][y] = 1
			elif neighbour_count < smooth_check:
				map[x][y] = 0

func get_surrounding_wall_count(grid_x, grid_y) -> int:
	var wall_count: int = 0
	for x in 3:
		for y in 3:
			var neighbour_x: int = grid_x + x - 1
			var neighbour_y: int = grid_y + y - 1
			if not (neighbour_x >= 0 and neighbour_x < width and neighbour_y >= 0 and neighbour_y < height):
				wall_count += 1
				continue
			if (neighbour_x != grid_x || neighbour_y != grid_y):
				wall_count += map[neighbour_x][neighbour_y] 
	return wall_count

func copy_to_tilemap(target: TileMap, source: TileMap, pos: Vector2i):
	var source_layer_count: int = source.get_layers_count()
	var target_layer_count: int = target.get_layers_count()
	
	for layer in source_layer_count:
		var used_cells: Array = source.get_used_cells(layer)
		if used_cells.size() < 1:
			return
		print(used_cells)
		var pattern: TileMapPattern = source.get_pattern(layer, used_cells)
		if layer > (target_layer_count - 1):
			target.add_layer(layer)
		target.set_pattern(layer, pos + used_cells[0], pattern)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
