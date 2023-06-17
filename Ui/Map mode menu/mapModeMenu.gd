extends Control

enum mapModes{ speed = 0, production = 1, defence = 2 }
var mapMode := mapModes.speed


func _on_speed_button_pressed():
	mapMode = mapModes.speed
	$"../../../Map-Information".updateTileMap()

func _on_pruduction_button_pressed():
	mapMode = mapModes.production
	$"../../../Map-Information".updateTileMap()

func _on_defence_button_pressed():
	mapMode = mapModes.defence
	$"../../../Map-Information".updateTileMap()
