extends Node2D

class_name BirdShooter


@export var poop_scene : PackedScene
@export var target_scene : Node2D
@export var default_shot_time : float
@export var triple_shot_angle : float = PI / 4
@export var triple_shot_time : float
@export var speed_shot_time : float
@export var obstacle_hit_time: float = 200
var triple_shot_offset : float = -PI / 2

var timer : float

var shot_time : float

@onready var fast_shot_time : float = default_shot_time * 0.5
@onready var obstacle_timer: float = obstacle_hit_time
@onready var triple_shot_timer: float = triple_shot_time
@onready var speed_shot_timer: float = speed_shot_time


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = default_shot_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	obstacle_timer += delta
	speed_shot_timer += delta
	triple_shot_timer += delta

	shot_time = default_shot_time
	
	if speed_shot_timer < speed_shot_time:
		shot_time = fast_shot_time
	if obstacle_timer >= obstacle_hit_time:
		if timer >= shot_time:
			if Input.is_action_pressed("ui_accept"):
				_shoot()
				timer = 0.0


func _shoot():
	var angle: float = get_parent().rotation + triple_shot_offset
	var shot_distance: float = (global_position - target_scene.global_position).length()
	
	var center_target : Vector2 = target_scene.global_position
	_shoot_poop(center_target)
	
	if triple_shot_timer < triple_shot_time:
		var left_target : Vector2 = global_position + Vector2(shot_distance * cos(-triple_shot_angle + angle), shot_distance * sin(-triple_shot_angle + angle))
		var right_target : Vector2 = global_position + Vector2(shot_distance * cos(triple_shot_angle + angle), shot_distance * sin(triple_shot_angle + angle))
		# Don't track accuracy for extra shots on triple shot since you can't aim them as well
		_shoot_poop(left_target, false)
		_shoot_poop(right_target, false)


func _shoot_poop(target : Vector2, track_accuracy : bool = true):
	var poop = poop_scene.instantiate()
	get_parent().get_parent().add_child(poop)
	poop.set_global_position(global_position)
	poop.set_initial_position(global_position)
	poop.set_target_destination(target)
	if not track_accuracy:
		poop.cancel_accuracy_tracking()


func powerup_triple_shot():
	triple_shot_timer = 0.0


func powerup_shot_up():
	speed_shot_timer = 0.0


func obstacle_collision():
	obstacle_timer = 0
