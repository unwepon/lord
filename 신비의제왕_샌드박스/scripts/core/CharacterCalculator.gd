# res://scripts/CharacterCalculator.gd
# 캐릭터의 모든 파생 능력치(생명력, 영성 등)를 계산하는 전문가입니다.
extends Node

# 캐릭터의 모든 능력치를 DataManager의 규칙에 따라 재계산하는 함수
func calculate_all_stats(character: CharacterResource) -> void:
	if not is_instance_valid(character):
		return

	# 기본 속성값들을 미리 변수에 저장해둡니다.
	var health = character.attributes.get("건강", 0)
	var will = character.attributes.get("의지", 0)
	var inspiration = character.attributes.get("영감", 0)
	
	# 1. 생명력(Health Points) 계산
	# JSON 규칙: TotalHP = ( (initialHealth + 10) + ... ) * tierBonusMultiplier
	# 현재는 비초월자(서열 10) 기준의 가장 기본적인 공식만 적용합니다.
	character.max_hp = health + 10
	character.hp = character.max_hp

	# 2. 이성(Sanity) 계산
	# JSON 규칙: base_formula: "will + 10"
	character.max_sanity = will + 10
	character.sanity = character.max_sanity
	
	# 3. 영성(Spirituality) 계산
	# JSON 규칙: TotalSpirituality = ( (initialWill + initialInspiration) + ... ) * tierBonusMultiplier
	# 현재는 비초월자(서열 10) 기준의 가장 기본적인 공식만 적용합니다.
	character.max_spirituality = will + inspiration
	character.spirituality = character.max_spirituality

	print("능력치 계산 완료: HP=%d, Sanity=%d, Spirituality=%d" % [character.max_hp, character.max_sanity, character.max_spirituality])
