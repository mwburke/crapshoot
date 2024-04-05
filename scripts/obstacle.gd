extends Area2D

class_name Obstacle


signal obstacle_collision


func _on_area_entered(_area):
	obstacle_collision.emit()
	queue_free()
