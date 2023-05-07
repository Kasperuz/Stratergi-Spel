extends Node2D

@export var positions: PackedVector2Array

func update():
	$Line2D.points = positions
	if len(positions) > 1:
		$Polygon2D.position = positions[0]
		$Polygon2D.rotation = positions[1].angle_to_point(positions[0])
