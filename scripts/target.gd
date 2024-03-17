extends Node2D

class_name Target

@export var move_speed : float = 1.0
@export var splat : PackedScene # = preload("res://scenes/splats/splat_00.tscn")

var num_collisions : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var sensor_body = get_node("SensorBody")
	sensor_body.connect("body_entered", _on_sensor_entered)
	sensor_body.connect("body_exited", _on_sensor_exited)


func _process(delta):
	if num_collisions == 0:
		# No collisions, free to move forward
		var direction = get_rotation()
		position += direction * move_speed * delta


func handle_hit(position : Vector2):
	var offset = self.global_position - position
	var splat_instance = splat.instantiate()
	splat_instance.set_position(offset);
	splat_instance.rotation = randf() * PI * 2


func _on_sensor_entered():
	num_collisions += 1
	
	
func _on_sensor_exited():
	num_collisions -= 1
	if num_collisions < 0:
		print("Negative collisions???")
