extends Node



# Movement
@export var max_turn_angle: float
@export var turn_speed_modifier: float

@export var max_horizontal_speed: float
@export var friction_speed: float

# Edge handling
@export var edge_limit_fraction: float

# Obstacle
@export var obstacle_hit_time: float
@export var obstacle_hit_timer: float
@export var speed_at_obstacle_hit: float


@export var collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer

var edge_limit_left: float
var edge_limit_right: float

@onready var horizontal_speed: float = 0.0

@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var world_size = get_viewport().get_visible_rect().size
@onready var is_active: bool = true
@onready var has_shield: bool = false
@onready var parent: Node = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("fly")
	set_edge_limits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_active:
		process_angle()
		process_movement(delta)


func process_movement(delta):
	var horizontal_input: float = 0
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

	parent.position.x += horizontal_speed * delta


func process_angle():
	var fraction: float = horizontal_speed / max_horizontal_speed
	parent.rotation = fraction * max_turn_angle


func set_edge_limits():
	edge_limit_left = -world_size.x / 2 * edge_limit_fraction
	edge_limit_right = world_size.x / 2 * edge_limit_fraction
