extends Node



@export var available_obstacles : Array[PackedScene]
@export var min_time_powerup : int
@export var max_time_powerup : int
@export var obstacles : Node
@export var bird : Node2D

var timer = 0.0
var next_time : float
var screen_width : float
var screen_height : float

@onready var bird_movement : BirdMovement = bird.get_node("MovementController")
@onready var bird_shooter : BirdShooter = bird.get_node("ShooterController")


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_next_time()
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y


func _process(delta):
	timer += delta

	if timer >= next_time:
		_spawn_obstacle()
		_set_next_time()
		timer = 0.0


func _set_next_time():
	next_time = min_time_powerup + randf() * (max_time_powerup - min_time_powerup)


func _spawn_obstacle():
	var obstacle : Area2D = available_obstacles.pick_random().instantiate()
	obstacles.add_child(obstacle)
	obstacle.global_position.x = -screen_width / 2 + screen_width * randf()
	obstacle.global_position.y = bird.position.y - screen_height * 0.8
	obstacle.connect("obstacle_collision", _activate_collision)


func _activate_collision():
	# TODO: update score manager
	# TODO: animation and deletion??
	bird_movement.obstacle_collision()
	bird_shooter.obstacle_collision()
	queue_free()
