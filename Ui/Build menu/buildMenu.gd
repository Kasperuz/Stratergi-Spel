extends Control

enum lägen{ inget = 0, pruduktion = 1, försvar = 2, hastighet = 3}

var läge := lägen.inget

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		$"../../../Unit Maneger".syncNewUnit($"../../../Map-Information".capitals[MultiplayerManager.nuvarande_lag],MultiplayerManager.nuvarande_lag,10)
		$"../../../Pruduktion".pengar[MultiplayerManager.nuvarande_lag] -= 10
		$"../../../Pruduktion".update()
