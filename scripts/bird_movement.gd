extends Node

class_name BirdMovement

# Movement
@export var max_turn_angle: float
@export var turn_speed_modifier: float

@export var max_horizontal_speed: float
@export var friction_speed: float

# Edge handling
@export var edge_limit_fraction: float

# Obstacle
@export var obstacle_time: float
@export var hit_speed: float

@export var collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer

@export var vertical_speed: float
@export var speed_up_factor: float
@export var speed_up_time: float


var edge_limit_left: float
var edge_limit_right: float
var is_active: bool = true
var has_shield: bool = false


@onready var obstacle_timer: float = obstacle_time
@onready var speed_up_timer: float = speed_up_time
@onready var horizontal_speed: float = 0.0
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var world_size = get_viewport().get_visible_rect().size
@onready var parent: Node = get_parent()
@onready var player_state: PlayerState = PlayerState.FLYING


enum PlayerState {
	FLYING,
	COLLISION
}


# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_flight()
	_set_edge_limits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	obstacle_timer += delta
	speed_up_timer += delta

	_process_movement(delta)
	_process_angle()

	if player_state == PlayerState.FLYING:
		pass

	elif player_state == PlayerState.COLLISION:
		if obstacle_timer >= obstacle_time:
			_enter_flight()


func _is_sped_up():
	return speed_up_timer < speed_up_time


func _process_movement(delta):
	var horizontal_input: float = 0
	
	if player_state == PlayerState.FLYING:
		if Input.is_action_pressed("move_left"):
			horizontal_input = -1
		if Input.is_action_pressed("move_right"):
			horizontal_input = 1
		
	if parent.position.x <= edge_limit_left:
		horizontal_speed = min(horizontal_speed + turn_speed_modifier, max_horizontal_speed)
	elif parent.position.x >= edge_limit_right:
		horizontal_speed = max(horizontal_speed - turn_speed_modifier, -max_horizontal_speed)
	elif horizontal_input != 0:
		horizontal_speed = clampf(horizontal_speed + (horizontal_input * turn_speed_modifier), -max_horizontal_speed, max_horizontal_speed)
	else:
		if horizontal_speed < 0:
			horizontal_speed = min(0, horizontal_speed + friction_speed)
		elif horizontal_speed > 0:
			horizontal_speed = max(0, horizontal_speed - friction_speed)

	var speedup_frac: float = 0
	if _is_sped_up():
		speedup_frac = speed_up_factor

	if player_state == PlayerState.FLYING:
		parent.position.x += horizontal_speed * delta * (1 + speedup_frac)
		parent.position.y += vertical_speed * delta * (1 + speedup_frac)
	elif player_state == PlayerState.COLLISION:
		_process_collision_movement(delta)


func _process_collision_movement(delta : float):
	parent.position.y += hit_speed * delta 


func set_move_speed(new_speed : float):
	vertical_speed = new_speed


func _process_angle():
	var fraction: float = horizontal_speed / max_horizontal_speed
	parent.rotation = fraction * max_turn_angle


func _set_edge_limits():
	edge_limit_left = -world_size.x / 2 * edge_limit_fraction
	edge_limit_right = world_size.x / 2 * edge_limit_fraction


func speed_up_powerup():
	speed_up_timer = 0


func _enter_flight():
	player_state = PlayerState.FLYING
	animation_player.play("fly")


func obstacle_collision():
	# TODO: create collision timer object and listener?
	# TODO: set the speed_up_timer to the speed_up_time to disable
	player_state = PlayerState.COLLISION
	obstacle_timer = 0.0
