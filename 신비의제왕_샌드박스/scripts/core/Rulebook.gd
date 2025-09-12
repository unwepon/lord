# res://scripts/core/Rulebook.gd
extends Node

# --- 속성 관련 규칙 ---
func get_attribute_definition(attr_id: String) -> Dictionary:
	for definition in DataManager.attributes_rules.get("attribute_definitions", []):
		if definition.get("attribute_id") == attr_id:
			return definition
	return {}

func get_damage_bonus_string(attribute_score: int) -> String:
	var bonus_table = DataManager.attributes_rules.get("damage_bonus_rules", {}).get("attribute_damage_bonus", {}).get("tiers", {}).get("normal", {}).get("values", {})
	return bonus_table.get(str(attribute_score), "0")

# --- 기능 관련 규칙 ---
func get_skill_bonus(rank_name: String) -> int:
	var rank_data = DataManager.skills_rules.get("skill_ranks", {}).get(rank_name, {})
	return rank_data.get("value", -4)

# 여기에 앞으로 다른 규칙 검색 함수들을 계속 추가해 나갈 것입니다.
