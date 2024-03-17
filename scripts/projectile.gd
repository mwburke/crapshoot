extends Node2D 


var time : float = 0
@export var life_time: float = 1
var initial_position: Vector2
var target_destination: Vector2
var hit_body : Area2D = null

signal target_hit(target : Area2D, hit_position : Vector2)


func _ready():
	var area = get_node("Area2D")
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	time += delta
	
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


func _handle_landing():
	"""
	Check for collision with target(s) and send out signal
	"""
	if hit_body != null:
		_handle_hit(hit_body)
	queue_free()


func _on_body_entered(body):
	hit_body = body


func _on_body_exited(_body):
	hit_body = null


func _handle_hit(body):
	target_hit.emit(body, global_position)
