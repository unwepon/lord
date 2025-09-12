# res://scripts/game_objects/Inventory.gd
extends RefCounted
class_name Inventory

var character: CharacterResource
# [수정] Array 타입을 ItemContainer로 변경
var equipped_containers: Array[ItemContainer] = []
var held_items: Array[BaseItem] = []

func _init(p_character: CharacterResource):
	self.character = p_character

func get_total_load() -> float:
	var total_load = 0.0
	for container in equipped_containers:
		total_load += container.get_current_load()
	for item in held_items:
		total_load += item.size * item.quantity
	return total_load

# [수정] 함수의 파라미터 타입을 ItemContainer로 변경
func equip_container(container: ItemContainer):
	if not container in equipped_containers:
		equipped_containers.append(container)
		print("'%s'이(가) '%s'을(를) 장착했습니다." % [character.character_name, container.item_name])

func add_item(item: BaseItem, container_name: String):
	for c in equipped_containers:
		if c.item_name == container_name:
			# TODO: 아이템 추가 로직 구현 (ItemContainer 클래스에)
			print("'%s'에 '%s' 아이템 추가 시도." % [container_name, item.item_name])
			return
	print("오류: '%s' 컨테이너를 찾을 수 없습니다." % container_name)
