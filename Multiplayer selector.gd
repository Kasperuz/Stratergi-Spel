extends Control

const PORT = 9978

var värde = 0

func _on_server_pressed():
	MultiplayerManager.create_server(PORT)
	get_tree().change_scene_to_file("res://Game World.tscn")


func _on_client_pressed():
	MultiplayerManager.create_client(PORT,$CenterContainer/HBoxContainer/TextEdit.text)
	get_tree().change_scene_to_file("res://Game World.tscn")
