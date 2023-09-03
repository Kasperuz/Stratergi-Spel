extends Control

enum lägen{ inget = 0, pruduktion = 1, försvar = 2, hastighet = 3}

var läge := lägen.inget

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	if läge > lägen.inget:
		pass
	

func _on_pruducton_check_button_pressed():
	läge = lägen.pruduktion


func _on_försvar_check_button_pressed():
	läge = lägen.försvar


func _on_hastighet_check_button_pressed():
	läge = lägen.hastighet


func _on_check_button_pressed():
	läge = lägen.inget


func _on_gubbar_button_pressed():
	if $"../../../Pruduktion".pengar[MultiplayerManager.nuvarande_lag] >= 10:
		if multiplayer.is_server():
			$"../../../Unit Maneger".newUnit($"../../../Map-Information".capitals[MultiplayerManager.nuvarande_lag],MultiplayerManager.nuvarande_lag,10)
		else:
			$"../../../Unit Maneger".rpc("newUnit",$"../../../Map-Information".capitals[MultiplayerManager.nuvarande_lag],MultiplayerManager.nuvarande_lag,10)
		$"../../../Pruduktion".pengar[MultiplayerManager.nuvarande_lag] -= 10
		$"../../../Pruduktion".update()
