extends Node2D

class_name BirdShooter


@export var poop_scene : PackedScene
@export var target_scene : Node2D
@export var default_shot_time : float = 0.7
@export var triple_shot_angle : float = PI / 4
@export var triple_shot_time : float
@export var speed_shot_time : float
var triple_shot_offset : float = -PI / 2

var timer : float

var fast_shot_time : float = default_shot_time * 0.7
var shot_time : float

var obstacle_time: float = Globals.obstacle_hit_time

@onready var obstacle_timer: float = obstacle_time
@onready var triple_shot_timer: float = triple_shot_time
@onready var speed_shot_timer: float = speed_shot_time


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = default_shot_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	shot_time = default_shot_time
	if speed_shot_timer < speed_shot_time:
		shot_time = fast_shot_time
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
		_shoot_poop(left_target)
		_shoot_poop(right_target)


func _shoot_poop(target : Vector2):
	var poop = poop_scene.instantiate()
	get_parent().get_parent().add_child(poop)
	poop.set_global_position(global_position)
	poop.set_initial_position(global_position)
	poop.set_target_destination(target)


func powerup_triple_shot():
	triple_shot_timer = 0.0


func powerup_shot_up():
	speed_shot_timer = 0.0


func obstacle_collision():
	obstacle_timer = 0
