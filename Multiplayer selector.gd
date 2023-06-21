extends Control


var värde = 0

func _on_server_pressed():
	MultiplayerManager.createServer()
	get_tree().change_scene_to_file("res://Game World.tscn")


func _on_client_pressed():
	MultiplayerManager.createClient()
	get_tree().change_scene_to_file("res://Game World.tscn")
