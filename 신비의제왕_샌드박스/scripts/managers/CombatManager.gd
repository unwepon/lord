# res://scripts/managers/CombatManager.gd
# 전투의 시작, 턴 순서, 종료 등 전체적인 흐름을 지휘합니다.
extends Node

var combatants: Array[CharacterResource] = []
var turn_order: Array[CharacterResource] = []
var round_count: int = 0
var is_combat_active: bool = false

# 전투 시작을 선언하는 함수
func start_combat(participants: Array[CharacterResource]):
	print("CombatManager: 전투를 시작합니다!")
	self.combatants = participants
	self.round_count = 1
	self.is_combat_active = true
	
	# 1. 선제권 계산
	var initiative_rolls = {}
	for char in combatants:
		var roll = _calculate_initiative(char)
		initiative_rolls[char] = roll
		print("  - %s의 선제권: %d" % [char.character_name, roll])

	# 2. 선제권에 따라 턴 순서 정렬
	turn_order = combatants.duplicate() # 원본 배열 복사
	turn_order.sort_custom(func(a, b): return initiative_rolls[a] > initiative_rolls[b])
	
	var turn_order_names = []
	for char in turn_order:
		turn_order_names.append(char.character_name)
	print("  - 행동 순서: %s" % ", ".join(turn_order_names))

# 선제권 계산 함수 (combat_flow_rules.json 참조)
func _calculate_initiative(character: CharacterResource) -> int:
	var inspiration = character.base_attributes.get("영감", 0)
	var agility = character.base_attributes.get("민첩", 0)
	return randi_range(1, 20) + inspiration + agility

# 전투 종료 조건을 확인하는 함수
func is_combat_over() -> bool:
	var players_alive = false
	var enemies_alive = false
	
	for char in combatants:
		if char.current_hp > 0:
			# TODO: 캐릭터 리소스에 is_player 속성 추가 필요
			# if char.is_player:
			if "플레이어" in char.character_name: # 임시
				players_alive = true
			else:
				enemies_alive = true
				
	return not (players_alive and enemies_alive)
