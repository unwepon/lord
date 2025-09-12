# res://scripts/game_objects/ItemContainer.gd
extends BaseItem
class_name ItemContainer

var capacity: int
var items: Array[BaseItem] = []

func _init(p_id, p_name, p_size: float, p_desc, p_capacity: int):
	super._init(p_id, p_name, p_size, p_desc)
	self.capacity = p_capacity

func get_current_load() -> float:
	var load = 0.0
	for item in items:
		load += item.size * item.quantity
	return load
