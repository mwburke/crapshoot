extends Node2D


@export var bird : Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.y = bird.position.y
