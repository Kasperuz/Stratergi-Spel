class_name UnitManeger

extends Node

const unit = preload("res://Ui/Unit/unit.tscn")

var positions: Array
var nodes: Array
var colors: Array
var sizes: Array
var schedules: Array
var scheduleTimers: Array
var antalGubbar: Array

func syncSetSize(unit,size):
	setSize(unit,size)
	rpc("setSize",unit,size)
@rpc("any_peer")
func setSize(unit,size):
	sizes[unit] = size

func ta_bort_gubbe(gubbe: int):
	
	nodes[gubbe].queue_free()
	
	positions.remove_at(gubbe)
	nodes.remove_at(gubbe)
	colors.remove_at(gubbe)
	sizes.remove_at(gubbe)
	schedules.remove_at(gubbe)
	scheduleTimers.remove_at(gubbe)
	for i in range(len($"../Selector".selected)):
		if $"../Selector".selected[i] == gubbe:
			$"../Selector".selected.remove_at(i)
			break
	for i in range(len($"../Selector".selected)):
		if $"../Selector".selected[i] > gubbe:
			$"../Selector".selected[i] -= 1
	for i in range(len(nodes)):
		if nodes[i].index > gubbe:
			nodes[i].index -= 1
func syncNewUnit(position: Vector2i,color,size):
	print("A player with a peer id of: ",multiplayer.get_unique_id(), " has created a new unit at the position of: ", position, " and at the size of: ",size)
	rpc("newUnit",position,color,size)
	newUnit(position,color,size)
		
@rpc("any_peer")
func newUnit(position: Vector2i,color,size):

	nodes.append(null)
	nodes[len(nodes)-1] = unit.instantiate()
	$"..".add_child.call_deferred(nodes[len(nodes)-1])
	nodes[len(nodes)-1].index = len(nodes)-1
	
	#arrows[len(arrows)-1] = arrow.instantiate()
	#$"..".add_child.call_deferred(arrows[len(arrows)-1])
	
	positions.append(position)
	
	colors.append(color)
	nodes[len(nodes)-1].color = color
	sizes.append(size)
	
	schedules.append([])
	scheduleTimers.append(0.0)

func lineAlgorithm(p1:Vector2i,p2:Vector2i):
	var len = Vector2(p2.x - p1.x, p2.y - p1.y)
	var r = ceil(sqrt(len.x * len.x + len.y * len.y))
	var position = Vector2(p1.x, p1.y)
	var slope = Vector2(len.x / r, len.y / r)
	var error = Vector2(0,0)
	var points = []
	points.append(Vector2i(position))
	for i in range(r):
		position += slope;
		points.append(Vector2i(round(position)))
	return points
	
func syncSetSchedule(unit:int, list:Array):
	setSchedule(unit,list)
	rpc("setSchedule",unit,list)
	
@rpc("any_peer")
func setSchedule(unit:int, list:Array):
	scheduleTimers[unit] = 0
	list.insert(0,positions[unit])
	schedules[unit] = []
	for i in range(len(list)-1):
		schedules[unit].append_array(lineAlgorithm(list[i],list[i+1]))

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"../CanvasLayer/Ui/VBoxContainer/Soldater/Label".text = "Soldater: "+ str(antalGubbar[MultiplayerManager.nuvarande_lag])
	for i in range(len(nodes)):
		
		nodes[i].size = sizes[i]
#		arrows[i].visible = false
		if len(schedules[i]) > 0:
#			arrows[i].visible = true
#			arrows[i].positions = PackedVector2Array([])
#			var i2 = len(schedules[i])
#			for index in range(len(schedules[i])):
#				i2 -= 1
#				arrows[i].positions.append($"../TileMap".to_global($"../TileMap".map_to_local(schedules[i][i2])))
#			arrows[i].update()

			scheduleTimers[i] += delta
			if scheduleTimers[i] > ($"../Map-Information".speed[positions[i].x][positions[i].y] ** 2) * 7:
				scheduleTimers[i] = 0
				
				var ledig = true
				for i3 in range(len(positions)):
					if i3 == i:
						continue
					if positions[i3] == schedules[i][0]:
						if colors[i3] == colors[i]:
							if len(schedules[i]) == 1 and len(schedules[i3]) == 0:
								sizes[i] += sizes[i3]
								sizes[i3] = 0
						else:
							var försvars_antal = clamp(sizes[i3],0,20)
							var attack_antal = clamp(sizes[i],0,30)
							var p = attack_antal / (attack_antal  + försvars_antal * ($"../Map-Information".defence[positions[i3].x][positions[i3].y] + 1))
							if randf() < p:
								sizes[i3] -= försvars_antal
							else:
								sizes[i] -= attack_antal
							ledig = false
					
				if ledig:
					positions[i] = schedules[i][0]
					schedules[i].remove_at(0)
		
		nodes[i].global_position = $"../TileMap".to_global($"../TileMap".map_to_local(positions[i]))
		if $"../Map-Information".land[positions[i].x][positions[i].y] != colors[i]:
			$"../Map-Information".land[positions[i].x][positions[i].y] = colors[i]
			$"../Map-Information".updateTileMap()
	for i in range(len(nodes)-1,-1,-1):
		if sizes[i] < 1:
			ta_bort_gubbe(i)
func _ready():
	antalGubbar.resize(MultiplayerManager.antal_lag)
	antalGubbar.fill(0)
