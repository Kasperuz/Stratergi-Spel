extends Control

const PORT = 9978

var värde = 0

var hostingMenu = preload("res://hosting_meny.tscn")

func _on_server_pressed():
	MultiplayerManager.create_server(PORT,$CenterContainer/HBoxContainer/Username.text)
	get_tree().change_scene_to_packed(hostingMenu)


func _on_client_pressed():
	MultiplayerManager.create_client(PORT,$CenterContainer/HBoxContainer/TextEdit.text,$CenterContainer/HBoxContainer/Username.text)
	get_tree().change_scene_to_packed(hostingMenu)
