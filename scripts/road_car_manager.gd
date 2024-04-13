extends Node


@export var creation_offset : float
@export var vert_target_offset : float
@export var dist_between_roads : float
@export var frac_screen_width_multiplier : float
@export var min_dist_frac_between_targets : float
@export var road_sprite : PackedScene
@export var target_parent : Node
@export var road_parent : Node

var screen_width : float
var dist_from_start : float
var target_array = []

var car_scene = preload("res://scenes/targets/car.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	dist_from_start = 0
	target_array.append(car_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dist_from_start += delta
	
	if dist_from_start > dist_between_roads:
		_generate_roads_and_targets()
		dist_from_start = dist_from_start - dist_between_roads

func _generate_roads_and_targets():
	print("generating roads and targets")
	var current_y = get_parent().global_position.y
	_generate_targets_direction(current_y + creation_offset - vert_target_offset, Vector2(-1, 0))
	_generate_targets_direction(current_y + creation_offset + vert_target_offset, Vector2(1, 0))
	
	# TODO: add in road creation
	var road_scene = road_sprite.instantiate()
	road_parent.add_child(road_scene)
	road_scene.global_position.y = current_y + creation_offset

func _generate_targets_direction(center_y : float, direction : Vector2):
	print(center_y)
	var offset = -frac_screen_width_multiplier * screen_width / 2
	var target_x = offset + (min_dist_frac_between_targets * screen_width) * (1 + randf())
	while target_x < frac_screen_width_multiplier * screen_width:
		var target_scene = target_array.pick_random().instantiate()
		target_parent.add_child(target_scene)
		target_scene.global_position.x = target_x
		target_scene.global_position.y = center_y
		target_scene.set_direction(direction)
		if direction == Vector2(-1, 0):
			target_scene.scale.x *= -1
		
		target_x += (min_dist_frac_between_targets * screen_width) * (1 + randf())
