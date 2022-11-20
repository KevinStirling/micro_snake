extends Node2D

@onready var grid = $TileMap;
@onready var timer = $Timer;
@onready var snake_head = preload("res://Snake/Snake.tscn");
@onready var snake_segment = preload("res://Snake/SnakeTail.tscn");
@onready var apple = preload("res://Apple/Apple.tscn");
@onready var score_label = $ScoreLabel

var snake
var playarea_coords 
var min_nav_x_y : Vector2
var max_nav_x_y : Vector2
var current_state := GlobalVars.State.PAUSE

var score : int

func set_state(new_state: GlobalVars.State):
	current_state = new_state
	match current_state:
		GlobalVars.State.PLAY:
			timer.start()
			timer.paused = false
		GlobalVars.State.PAUSE:
			timer.paused = true
		GlobalVars.State.DEAD:
			timer.stop()

func _ready():
	playarea_coords = grid.get_used_cells(1)
	playarea_coords = playarea_coords.sort()
	min_nav_x_y = playarea_coords[0]
	max_nav_x_y = playarea_coords[playarea_coords.size() - 1]
	
	timer.timeout.connect(_timer_timeout)
	snake = snake_head.instantiate()
	for s in range(snake.grid_coords.size()):
		if s == 0:
			add_child(snake)
			snake.position = grid.map_to_local(snake.grid_coords[s])
			snake.body_segments.push_front(snake)
		else:
			update_snake(s)
	_new_apple()
	score = 0
	score_label.text = str(score)
	
func update_snake(grid_coords_pos = snake.grid_coords.size() - 1):
	var current_segment = snake_segment.instantiate()
	add_child(current_segment)
	current_segment.position = grid.map_to_local(snake.grid_coords[grid_coords_pos])
	snake.body_segments.append(current_segment)
	score += 1
	score_label.text = str(score)

func _timer_timeout():
	var segment_next
	var segment_previous
	if snake.grid_coords.size() > snake.body_segments.size() :
		update_snake()
	for s in range(snake.grid_coords.size()):
		if s == 0:
			if !is_in_boundaries(snake.grid_coords[s]):
				set_state(GlobalVars.State.DEAD)
			segment_next = snake.grid_coords[s]
			snake.grid_coords[s] = snake.grid_coords[s] + snake.input_buffer
			snake.position = grid.map_to_local(snake.grid_coords[s])
		else:
			grid.erase_cell(2, snake.grid_coords[s])
			segment_previous = snake.grid_coords[s]
			snake.grid_coords[s] = segment_next
			snake.body_segments[s].position = grid.map_to_local(snake.grid_coords[s])
			segment_next = segment_previous
	if current_state == GlobalVars.State.PLAY : 
		timer.start()

func is_in_boundaries(grid_coord):
	if (min_nav_x_y.x <= grid_coord.x) and (max_nav_x_y.x >= grid_coord.x):
		if (min_nav_x_y.y <= grid_coord.y) and (max_nav_x_y.y >= grid_coord.y):
			return true
	return false
	
func _new_apple():
	if get_node_or_null("Apple") == null :
		apple = apple.instantiate()
		add_child(apple)
		apple.spawn.connect(_new_apple)
	var temp_coords = playarea_coords 
	var new_apple_pos : Vector2 = temp_coords[randi() % temp_coords.size()]
	while snake.grid_coords.has(new_apple_pos):
		new_apple_pos = temp_coords.pick_random()
	apple.position = grid.map_to_local(new_apple_pos)

