extends StaticBody2D

@onready var col_area = $CollisionArea
@onready var manager = get_parent()

func _ready():
	col_area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body):
	if body.is_in_group("SnakeHead"):
		manager.set_state(GlobalVars.State.DEAD)
		manager.state_display.text = "[center]DEAD[/center]"
		manager.state_display.visible = true
