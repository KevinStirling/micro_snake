extends Node2D

@onready var pickUpArea = $PickUpBoundary

signal spawn

func _ready():
	pickUpArea.area_entered.connect(_area_pickup)
	
func _area_pickup(area):
	if area.get_parent().has_method("grow"):
		area.get_parent().grow()
		emit_signal("spawn")
