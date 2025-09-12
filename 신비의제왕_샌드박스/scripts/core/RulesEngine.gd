# res://scripts/core/RulesEngine.gd
# 모든 행동의 결과를 최종 판정하는 '게임 심판'입니다.
extends Node

# "1d6", "2d8+2" 같은 문자열을 받아 실제 주사위 굴림 값을 반환하는 헬퍼 함수
func _roll_dice_string(dice_str: String) -> int:
	if not "d" in dice_str:
		return int(dice_str)
	
	var total = 0
	var parts = dice_str.split("+")
	for part in parts:
		part = part.strip()
		if "d" in part:
			var dice_parts = part.split("d")
			var num_dice = int(dice_parts[0])
			var num_sides = int(dice_parts[1])
			for _i in range(num_dice):
				total += randi_range(1, num_sides)
		else:
			total += int(part)
	return total

# 행동 결과를 판정하는 메인 함수
func resolve_action(actor: CharacterResource, action_id: String, target: CharacterResource) -> Dictionary:
	# Rulebook에서 해당 행동의 규칙을 가져옵니다.
	# general_actions.json을 아직 DataManager에 로드하지 않았으므로, 임시 규칙을 사용합니다.
	var action_rule = {
		"check_attribute": "힘",
		"damage_dice": "1d4",
		"damage_attribute": "힘"
	}

	# --- 공격 판정 (1d20 + 속성 + 기능 vs 목표 방어) ---
	var attacker_roll = randi_range(1, 20)
	
	var attribute_name = action_rule.get("check_attribute", "힘")
	var attribute_bonus = actor.base_attributes.get(attribute_name, 0)
	
	var skill_rank = actor.skills.get(action_id, "untrained")
	var skill_bonus = Rulebook.get_skill_bonus(skill_rank)
	
	var attacker_total = attacker_roll + attribute_bonus + skill_bonus
	var defender_total = target.physical_defense
	
	var is_hit = attacker_total > defender_total
	
	# --- 피해 판정 ---
	var damage = 0
	if is_hit:
		var damage_dice = action_rule.get("damage_dice", "1d2")
		var base_damage = _roll_dice_string(damage_dice)
		
		var damage_attr_name = action_rule.get("damage_attribute", "힘")
		var damage_attr_score = actor.base_attributes.get(damage_attr_name, 0)
		var bonus_damage_str = Rulebook.get_damage_bonus_string(damage_attr_score)
		var bonus_damage = _roll_dice_string(bonus_damage_str)

		damage = base_damage + bonus_damage

	return {
		"hit": is_hit,
		"damage": damage,
		"log": "결과 %d (주사위 %d + %s %d + 기능 %d) vs 방어 %d" % [attacker_total, attacker_roll, attribute_name, attribute_bonus, skill_bonus, defender_total]
	}
