extends Node2D

@export var world_size = 200
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var camera: Camera2D = player.get_node("Camera2D")
@onready var zombie_scene = preload("res://scenes/zombie.tscn")
@onready var tile_map = $TileMap
@onready var enemies = $Enemies

func get_random_position_in_view() -> Vector2:
	# Get the size of the viewport
	var viewport_size = get_viewport_rect().size
	
	# Get the camera's position and zoom level
	var camera_position = camera.global_position
	var camera_zoom = camera.zoom

	# Calculate the visible area
	var view_width = viewport_size.x * camera_zoom.x
	var view_height = viewport_size.y * camera_zoom.y

	# Calculate the bounds of the view rectangle
	var left = camera_position.x - view_width / 2
	var right = camera_position.x + view_width / 2
	var top = camera_position.y - view_height / 2
	var bottom = camera_position.y + view_height / 2

	# Generate random coordinates within the view rectangle
	var random_x = randi_range(left, right)
	var random_y = randi_range(top, bottom)

	return Vector2(random_x, random_y)

func generate_random_tilemap():
	for x in range(world_size):
		for y in range(world_size):
			tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0)

	var block_number = (randi() % (world_size * 4)) + 1
	for i in range(block_number):
		var x = (randi() % world_size) + 1
		var y = (randi() % world_size) + 1
		
		tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0)
		
func generate_enemy():
	var new_position = get_random_position_in_view()
	var enemy = zombie_scene.instantiate()
	enemy.global_position = new_position
	enemies.add_child(enemy)

func _ready():
	generate_random_tilemap()
