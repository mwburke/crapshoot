extends Node2D

class_name Target

@export var move_speed : float = 1.0
@export var splat : PackedScene # = preload("res://scenes/splats/splat_00.tscn")
@export var move_direction : Vector2

const move_adjust_frac : float = 0.3


func _ready():
	_adjust_move_speed()


func _process(delta):
	position += move_direction * move_speed * delta


func set_direction(direction : Vector2):
	move_direction = direction


func _adjust_move_speed():
	move_speed *= (1 + move_adjust_frac * (randf() - 0.5))


func handle_hit(hit_position : Vector2):
	var offset = hit_position - global_position
	var splat_instance = splat.instantiate()
	self.add_child(splat_instance)
	splat_instance.set_position(offset / scale.x);
	splat_instance.rotation = randf() * PI * 2
