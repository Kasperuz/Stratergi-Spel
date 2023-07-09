extends Control

@rpc("authority")
func setName(team: int,nameIn: String):
	get_node("VBoxContainer/"+str(team)+"/Label").text = nameIn
	get_node("VBoxContainer/"+str(team)+"/Host").visible = true

func _ready():
	if multiplayer.is_server():
		$Button.visible = true
	$Ip.text = str(MultiplayerManager.Ip)
func _process(_delta):
	for i in range(len(MultiplayerManager.names)):
		if not MultiplayerManager.names[i] == null:
			var temp = get_node("VBoxContainer/"+str(i))
			if MultiplayerManager.nuvarande_lag == i:
				temp.color.v = 0.8
			else:
				temp.color.v = 0.3
				
			if i == 5:
				temp.color.v =- 0.1
			
			if i == 1:
				temp.get_node("Host").visible = true
			temp.get_node("Label").text = MultiplayerManager.names[i]


func _on_button_pressed():
	if multiplayer.is_server():
		get_tree().change_scene_to_file("res://Game World.tscn")
		rpc("start")

@rpc("authority")
func start():
	get_tree().change_scene_to_file("res://Game World.tscn")
