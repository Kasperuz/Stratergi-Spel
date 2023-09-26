extends Timer



func _on_timeout():
	$"../Map-Information".rpc("updateMap",$"../Map-Information".land)
