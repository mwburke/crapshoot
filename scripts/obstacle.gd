extends Area2D

class_name Obstacle


signal obstacle_collision(obstacle : Obstacle)


func _on_area_entered(_area):
	obstacle_collision.emit(self)
	queue_free()
