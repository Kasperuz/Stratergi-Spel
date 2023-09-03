class_name UnitManeger

extends Node

const unitPreload = preload("res://Ui/Unit/unit.tscn")

var unixTime

var positions: Array
var nodes: Array
var colors: Array
var sizes: Array
var schedules: Array
var scheduleTimers: Array
var antalGubbar: Array

func setSize(unit,size):
	if !multiplayer.is_server():
		breakpoint
	sizes[unit] = size

func ta_bort_gubbe(gubbe: int):
	if multiplayer.is_server():
		nodes[gubbe].queue_free()
		nodes.remove_at(gubbe)
		for i in range(len(nodes)):
			if nodes[i].index > gubbe:
				nodes[i].index -= 1
	positions.remove_at(gubbe)
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

@rpc("any_peer")		
func newUnit(position: Vector2i,color,size):
	if multiplayer.is_server():
		nodes.append(null)
		nodes[len(nodes)-1] = unitPreload.instantiate()
		$"..".add_child.call_deferred(nodes[len(nodes)-1],true)
		nodes[len(nodes)-1].index = len(nodes)-1
		nodes[len(nodes)-1].color = color
	
		positions.append(position)
		
		colors.append(color)
		sizes.append(size)
		
		schedules.append([])
		scheduleTimers.append(0.0)

func lineAlgorithm(p1:Vector2i,p2:Vector2i):
	var l = Vector2(p2.x - p1.x, p2.y - p1.y)
	var r = ceil(sqrt(l.x * l.x + l.y * l.y))
	var position = Vector2(p1.x, p1.y)
	var slope = Vector2(l.x / r, l.y / r)
	var points = []
	points.append(Vector2i(position))
	for i in range(r):
		position += slope;
		points.append(Vector2i(round(position)))
	return points
	
	
func setSchedule(unit:int, list:Array):
	schedules[unit] = []
	list.insert(0,positions[unit])
	for i in range(len(list)-1):
		schedules[unit].append_array(lineAlgorithm(list[i],list[i+1]))
	scheduleTimers[unit] = Time.get_unix_time_from_system() + $"../Map-Information".speed[positions[unit].x][positions[unit].y]

#@rpc("any_peer")
#func sendSchedulesToServer(unit:int,scheduleiIn:Array):
#	if multiplayer.is_server():
#		schedules[unit] = scheduleiIn
#		scheduleTimers[unit] = unixTime + $"../Map-Information".speed[positions[unit].x][positions[unit].y]
		
	
func beräknaStrider(i):
	var ledig = true
	for i3 in range(len(positions)):
		if i3 == i:
			continue
		if positions[i3] == schedules[i][0]:
			if colors[i3] == colors[i]:
				if len(schedules[i]) == 1 and len(schedules[i3]) == 0:
					setSize(i,sizes[i] + sizes[i3])
					setSize(i3,0)
			else:
				var försvars_antal = clamp(sizes[i3],0,20)
				var attack_antal = clamp(sizes[i],0,30)
				var p = attack_antal / (attack_antal  + försvars_antal * ($"../Map-Information".defence[positions[i3].x][positions[i3].y] + 1))
				if randf() < p:
					setSize(i3,sizes[i3] - försvars_antal)
				else:
					setSize(i,sizes[i] - attack_antal)
				ledig = false
	if ledig:
		if len(schedules[i]) > 0:
			positions[i] = schedules[i][0]
			schedules[i].remove_at(0)
			scheduleTimers[i] += $"../Map-Information".speed[positions[i].x][positions[i].y]
		setPosition(i, positions[i])

func setPosition(unit,position):
	positions[unit] = position
		
		
	
	
# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	unixTime = Time.get_unix_time_from_system()
	$"../CanvasLayer/Ui/VBoxContainer/Soldater/Label".text = "Soldater: "+ str(antalGubbar[MultiplayerManager.nuvarande_lag])
	for i in range(len(positions)):
		
		if multiplayer.is_server():
			nodes[i].size = sizes[i]
			if len(schedules[i]) > 0:
				if scheduleTimers[i] < unixTime:
					beräknaStrider(i)
			nodes[i].global_position = $"../TileMap".to_global($"../TileMap".map_to_local(positions[i]))
				
		if $"../Map-Information".land[positions[i].x][positions[i].y] != colors[i]:
			$"../Map-Information".land[positions[i].x][positions[i].y] = colors[i]
			$"../Map-Information".updateTileMap()
	for i in range(len(positions)-1,-1,-1):
		if sizes[i] < 1:
			ta_bort_gubbe(i)
func _ready():
	antalGubbar.resize(MultiplayerManager.antal_lag)
	antalGubbar.fill(0)
