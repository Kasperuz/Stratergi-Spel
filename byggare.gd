extends Control

enum lägen{ inget = 0, gubbar = 1, pruduktion = 2, försvar = 3, hastighet = 4}

var läge := lägen.inget

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if läge > lägen.inget:
		if läge == lägen.gubbar and Input.is_action_just_pressed("Left click"):
			$"../../Unit Maneger".newUnit($"../../TileMap".local_to_map($"../../TileMap".get_local_mouse_position()),$"../Lag välgare".lag,100)
	

func _on_gubbar_check_button_pressed():
	läge = lägen.gubbar


func _on_pruducton_check_button_pressed():
	läge = lägen.pruduktion


func _on_försvar_check_button_pressed():
	läge = lägen.försvar


func _on_hastighet_check_button_pressed():
	läge = lägen.hastighet


func _on_check_button_pressed():
	läge = lägen.inget
