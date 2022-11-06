extends StaticBody2D

# any way to ensure a game manager is attached to this node via code or editor?
@onready var manager = get_parent()
@onready var snake_segment = "res://Snake/SnakeTail.tscn"

var input_buffer := Vector2.ZERO

var grid_coords := [Vector2(21, 22), Vector2(22,22), Vector2(23,22), Vector2(24,22)]
var body_segments: Array

func grow():
#	var new_seg = grid_coords[grid_coords.size() - 1] + (grid_coords[grid_coords.size() - 2] - grid_coords[grid_coords.size() - 1])
	var new_seg = grid_coords[grid_coords.size() - 1]
	grid_coords.append(new_seg)
	

func _process(_delta):
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		if manager.current_state == GlobalVars.State.PAUSE :
			manager.set_state(GlobalVars.State.PLAY)
	if Input.is_action_just_pressed("left"):
		input_buffer = Vector2(-1, 0)
	elif Input.is_action_just_pressed("right"):
		input_buffer = Vector2(1, 0)
	elif Input.is_action_just_pressed("up"):
		input_buffer = Vector2(0, -1)
	elif Input.is_action_just_pressed("down"):
		input_buffer = Vector2(0 ,1)

