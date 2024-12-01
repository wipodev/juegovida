extends TileMap

var width = 72
var height = 40
var board = {}

func init_board() -> Dictionary:
	var initboard = {}
	for x in width:
		for y in height:
			var pos = Vector2(x,y)
			var rand = randi_range(0,100)
			initboard[pos] = 1 if rand > 80 else 0
	return initboard

func new_generation(previous_board: Dictionary) -> Dictionary:
	
	var newboard = {}
	for x in width:
		for y in height:
			var pos = Vector2(x,y)
			var neighbors = {
				tl = pos + Vector2(-1,-1),
				t = pos + Vector2(0,-1),
				tr = pos + Vector2(1,-1),
				l = pos + Vector2(-1,0),
				r = pos + Vector2(1,0),
				bl = pos + Vector2(-1,1),
				b = pos + Vector2(0,1),
				br = pos + Vector2(1,1)
			}
			var neighbors_total = 0
			for i in neighbors.values():
				if i.x < 0 and i.y < 0:
					neighbors_total += previous_board[Vector2(width-1,height-1)]
				elif i.x >= width and i.y >= height:
					neighbors_total += previous_board[Vector2(0,0)]
				elif i.x < 0 and i.y >= height:
					neighbors_total += previous_board[Vector2(width-1,0)]
				elif i.x >= width and i.y < 0:
					neighbors_total += previous_board[Vector2(0,height-1)]
				elif i.x >= 0 and i.y < 0:
					neighbors_total += previous_board[Vector2(i.x,height-1)]
				elif i.x < 0 and i.y >= 0:
					neighbors_total += previous_board[Vector2(width-1,i.y)]
				elif i.x >= 0 and i.y >= height:
					neighbors_total += previous_board[Vector2(i.x,0)]
				elif i.x >= width and i.y >= 0:
					neighbors_total += previous_board[Vector2(0,i.y)]
				else:
					neighbors_total += previous_board[i]
				
			if neighbors_total == 3:
				newboard[pos] = 1
			elif neighbors_total > 3:
				newboard[pos] = 0
			elif neighbors_total < 2:
				newboard[pos] = 0
			else:
				newboard[pos] = previous_board[pos]
	return newboard

func draw_board() -> void:
	for x in width:
		for y in height:
			var pos = Vector2(x,y)
			if board[pos] == 1:
				set_cell(0,pos,0,Vector2i(0,0))
			else:
				set_cell(0,pos,-1)
				
func _ready():
	board = init_board()
	draw_board()
	
func _process(_delta):
	board = new_generation(board)
	draw_board()
