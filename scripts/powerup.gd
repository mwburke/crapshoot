extends Area2D

class_name Powerup

@export var powerup_name: String

signal powerup_collected(powerup : String)


func _on_area_entered(_area):
	print('on area entered')
	powerup_collected.emit(powerup_name)
	queue_free()
