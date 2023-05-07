class_name UnitManeger

extends Node

const unit = preload("res://Unit/Unit.tscn")
const arrow = preload("res://Unit/Arrow/Arrow.tscn")

var positions: Array
var nodes: Array
var arrows: Array
var colors: Array
var sizes: Array
var schedules: Array
var scheduleTimers: Array

func newUnit(position,color,size):
	nodes.append(null)
	nodes[len(nodes)-1] = unit.instantiate()
	$"..".add_child.call_deferred(nodes[len(nodes)-1])
	
	arrows.append(null)
	arrows[len(arrows)-1] = arrow.instantiate()
	$"..".add_child.call_deferred(arrows[len(arrows)-1])
	
	positions.append(position)
	
	colors.append(color)
	nodes[len(nodes)-1].color = color-1
	sizes.append(size)
	
	schedules.append([])
	scheduleTimers.append(0.0)

func bresenhamsAlgorithm(p1:Vector2i,p2:Vector2i):
	var output = []
	var m_new = 2 * (p2.y - p1.y)
	var slope_error_new = m_new - (p2.x - p1.x)
 
	var y = p1.y
	for x in range(p1.x, p2.x+1):
		output.append(Vector2i(x,y))
		slope_error_new = slope_error_new + m_new

		if slope_error_new >= 0:
			y = y+1
			output.append(Vector2i(x,y))
			slope_error_new = slope_error_new - 2 * (p2.x - p1.x)
	return output

func setSchedule(unit:int, list:Array):
	schedules[unit] = []
	for i in range(len(list)-1):
		schedules[unit] = bresenhamsAlgorithm(list[i],list[i+1])
		print(schedules[unit])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(len(nodes)):
		nodes[i].size = sizes[i]
		arrows[i].visible = false
		if len(schedules[i]) > 0:
			arrows[i].visible = true
			arrows[i].positions = PackedVector2Array([])
			var i2 = len(schedules[i])
			for index in range(len(schedules[i])):
				i2 -= 1
				arrows[i].positions.append($"../TileMap".to_global($"../TileMap".map_to_local(schedules[i][i2])))
			arrows[i].update()
			
			scheduleTimers[i] += delta
			if scheduleTimers[i] > $"../Map-Information".speed[positions[i].x][positions[i].y]:
				scheduleTimers[i] = 0
				positions[i] = schedules[i][0]
				schedules[i].remove_at(0)
		nodes[i].global_position = $"../TileMap".to_global($"../TileMap".map_to_local(positions[i]))
		if $"../Map-Information".land[positions[i].x][positions[i].y] != colors[i]:
			$"../Map-Information".land[positions[i].x][positions[i].y] = colors[i]
			$"../Map-Information".updateTileMap()
func _ready():
	newUnit(Vector2i(0,0),1,300)
	setSchedule(0,[
				Vector2i(1,1),
				Vector2i(5,20)])
