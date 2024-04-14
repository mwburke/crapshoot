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
var last_checkpoint : float
var target_array = []

var car_scene = preload("res://scenes/targets/car.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	last_checkpoint = get_parent().global_position.y
	target_array.append(car_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (last_checkpoint - get_parent().global_position.y) > dist_between_roads:
		_generate_roads_and_targets()
		last_checkpoint = get_parent().global_position.y


func _generate_roads_and_targets():
	var current_y = get_parent().global_position.y
	_generate_targets_direction(current_y - vert_target_offset * 3 / 5 + creation_offset - vert_target_offset, Vector2(-1, 0))
	_generate_targets_direction(current_y + creation_offset + vert_target_offset, Vector2(1, 0))
	
	var road_scene = road_sprite.instantiate()
	road_parent.add_child(road_scene)
	road_scene.global_position.y = current_y + creation_offset


func _generate_targets_direction(center_y : float, direction : Vector2):
	var offset = -frac_screen_width_multiplier * screen_width
	var target_x = offset + (min_dist_frac_between_targets * screen_width) * (1 + randf())
	while target_x < frac_screen_width_multiplier * screen_width * 2:
		var target_scene = target_array.pick_random().instantiate()
		target_parent.add_child(target_scene)
		target_scene.global_position.x = target_x
		target_scene.global_position.y = center_y
		target_scene.set_direction(direction)
		if direction == Vector2(-1, 0):
			target_scene.scale.x *= -1
		
		var sprite = target_scene.get_node("CarBase")
		var car_color = generate_color()
		sprite.modulate = car_color
		
		target_x += ((min_dist_frac_between_targets * screen_width) * (1.5 + randf()))



func generate_color() -> Color:
	var h = randf()
	var s = 0.7 + randf() * 0.3
	var b = 0.7 + randf() * 0.3
	
	var output_color = hsb2rgb(h, s, b)
	return output_color


func hsb2rgb(hue: float, saturation: float, brightness: float) -> Color:
	var r: float = 0.0
	var g: float = 0.0
	var b: float = 0.0

	var i : int = floor(hue * 6.0)
	var f = hue * 6.0 - i
	var p = brightness * (1.0 - saturation)
	var q = brightness * (1.0 - saturation * f)
	var t = brightness * (1.0 - saturation * (1.0 - f))

	if (i % 2 == 0):
		r = brightness
		g = q
		b = p
	elif (i == 1):
		r = t
		g = brightness
		b = p
	elif (i == 2):
		r = p
		g = brightness
		b = q
	elif (i == 3):
		r = p
		g = t
		b = brightness
	elif (i == 4):
		r = q
		g = p
		b = brightness
	else:
		r = brightness
		g = p
		b = t

	return Color(r, g, b)
