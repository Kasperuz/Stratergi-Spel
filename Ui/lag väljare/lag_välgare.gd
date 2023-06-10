extends Control

var lag := 1
const antal_lag := 11
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(1,antal_lag):
		if get_node("BoxContainer/"+str(i)+"/VSeparator/CheckButton").button_pressed:
			lag = i
			$"../../Pruduktion".update()
			break
