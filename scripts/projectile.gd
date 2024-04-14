extends Node2D 


@export var life_time: float = 1
@export var final_scale: float = 0.5

var time : float = 0
var initial_position: Vector2
var target_destination: Vector2
var hit_body : Area2D = null
var track_accuracy : bool = true

@onready var start_scale : float = scale.x

signal target_hit(target : Area2D, hit_position : Vector2, track_accuracy : bool)
signal target_missed


func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	connect("area_entered", _on_body_entered)
	connect("area_exited", _on_body_exited)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	time += delta
	
	scale.x = lerp(start_scale, start_scale * final_scale, time / life_time)
	scale.y = lerp(start_scale, start_scale * final_scale, time / life_time)
	
	if time >= life_time:
		_handle_landing()
	else:
		_move()

 
func _move():
	var fraction : float = time / life_time
	global_position = initial_position.lerp(target_destination, fraction)


func set_target_destination(target : Vector2):
	target_destination = target


func set_initial_position(initial_pos : Vector2):
	initial_position = initial_pos


func cancel_accuracy_tracking():
	track_accuracy = false


func _handle_landing():
	"""
	Check for collision with target(s) and send out signal
	"""
	if hit_body != null:
		_handle_hit(hit_body)
	else:
		if track_accuracy:
			target_missed.emit()

	queue_free()


func _on_body_entered(body):
	hit_body = body


func _on_body_exited(_body):
	hit_body = null


func _handle_hit(body):
	body.handle_hit(global_position)
	target_hit.emit(body, global_position, track_accuracy)
