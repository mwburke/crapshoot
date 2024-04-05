extends Node2D

class_name Target

@export var move_speed : float = 1.0
@export var splat : PackedScene # = preload("res://scenes/splats/splat_00.tscn")
@export var move_direction : Vector2


func _process(delta):
	position += move_direction * move_speed * delta


func set_direction(direction : Vector2):
	move_direction = direction


func handle_hit(hit_position : Vector2):
	var offset = self.global_position - hit_position
	var splat_instance = splat.instantiate()
	splat_instance.set_position(offset);
	splat_instance.rotation = randf() * PI * 2
