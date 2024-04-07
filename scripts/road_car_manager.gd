extends Node


@export var target_array : Array[Target]
@export var vert_target_offset : float
@export var dist_between_roads : float
@export var move_speed_adjust : float
@export var frac_screen_width_multiplier : float
@export var min_dist_frac_between_targets : float
@export var road_sprite : Sprite2D
@export var target_parent : Node
@export var road_parent : Node
	
var screen_width : float
var dist_from_start : float


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	dist_from_start = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dist_from_start += delta
	
	if dist_from_start > dist_between_roads:
		_generate_roads_and_targets()
		dist_from_start = dist_from_start - dist_between_roads

func _generate_roads_and_targets():
	var current_y = get_parent().global_position.y
	_generate_targets_direction(current_y + vert_target_offset, Vector2(-1, 0))
	_generate_targets_direction(current_y - vert_target_offset, Vector2(1, 0))
	
	# TODO: add in road creation
	


func _generate_targets_direction(center_y : float, direction : Vector2):
	var offset = -frac_screen_width_multiplier * screen_width / 2
	var target_x = offset + (min_dist_frac_between_targets * screen_width) * (1 + randf())
	while target_x < frac_screen_width_multiplier * screen_width:
		var target : Target = target_array.pick_random().instantiate()
		target_parent.add_child(target)
		target.global_position.x = target_x
		target.global_position.y = center_y
		target.set_direction(direction)
		
		target_x += (min_dist_frac_between_targets * screen_width) * (1 + randf())
