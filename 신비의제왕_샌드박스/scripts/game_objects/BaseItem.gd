# res://scripts/game_objects/BaseItem.gd
extends RefCounted
class_name BaseItem

const ItemSize = {
	"VERY_SMALL": 0.25, "SMALL": 0.5, "MEDIUM_SMALL": 1.0, "MEDIUM": 2.0
}

var item_id: String
var item_name: String
var size: float
var description: String
var quantity: int = 1

func _init(p_item_id: String = "", p_item_name: String = "", p_size: float = ItemSize.MEDIUM_SMALL, p_desc: String = ""):
	self.item_id = p_item_id
	self.item_name = p_item_name
	self.size = p_size
	self.description = p_desc
