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
	print($"../../../Pruduktion".pengar)
	if $"../../../Pruduktion".pengar[$"../Lag välgare".lag] >= 10:
		$"../../../Unit Maneger".newUnit($"../../../Map-Information".capitals[$"../Lag välgare".lag],$"../Lag välgare".lag,10)
		$"../../../Pruduktion".pengar[$"../Lag välgare".lag] -= 10
		$"../../../Pruduktion".update()
