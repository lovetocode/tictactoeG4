extends Node

@onready var player_panel = $PlayerPanel
@onready var board = $Board
@export var circle_scene: PackedScene
@export var cross_scene: PackedScene

var player: int
var grid_data: Array
var grid_pos: Vector2i
var player_panel_pos: Vector2i
var board_size: int
var cell_size: int
var temp_marker
var row_sum: int
var col_sum: int
var diagonal1_sum: int
var diagonal2_sum: int


# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = board.texture.get_width()
	# Divide board by 3 to get the individual size of each cell.
	cell_size = board_size / 3
	# Position on the panel on the right side of the board.
	player_panel_pos = player_panel.get_position()
	new_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				# convert mouse location into grid position
				grid_pos = Vector2i(event.position / cell_size)
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					player *= -1 
					# Place the players marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					# update the marker.
					temp_marker.queue_free() 
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
func new_game():
	player = 1
	grid_data = [
		[0,0,0],
		[0,0,0],
		[0,0,0]
		]
	 # Maker for the starting player's turn
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)

func create_marker(player, position, temp=false):
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp: temp_marker = circle 
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp: temp_marker = cross


