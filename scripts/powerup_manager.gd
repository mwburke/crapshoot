extends Node


@export var available_powerups : Array[PackedScene]
@export var min_time_powerup : int
@export var max_time_powerup : int
@export var powerups : Node
@export var bird : Node2D

var timer = 0.0
var next_time : float
var screen_width : float
var screen_height : float

var powerup_func_dict : Dictionary = {
	"speed_up": _activate_speed_up,
	"shot_up": _activate_shot_up,
	"triple_shot": _activate_triple_shot
}

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
		_spawn_powerup()
		_set_next_time()
		timer = 0.0


func _set_next_time():
	next_time = min_time_powerup + randf() * (max_time_powerup - min_time_powerup)


func _spawn_powerup():
	var powerup : Area2D = available_powerups.pick_random().instantiate()
	powerups.add_child(powerup)
	powerup.global_position.x = -screen_width / 2 + screen_width * randf()
	powerup.global_position.y = bird.position.y - screen_height * 0.8
	powerup.connect("powerup_collected", activate_powerup)


func activate_powerup(powerup_name):
	powerup_func_dict[powerup_name].call()


func _activate_speed_up():
	bird_movement.speed_up_powerup()


func _activate_shot_up():
	bird_shooter.powerup_shot_up()


func _activate_triple_shot():
	bird_shooter.powerup_triple_shot()
