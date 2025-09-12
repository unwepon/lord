# res://scripts/game_objects/CharacterResource.gd
# 규칙(Rulebook)을 기반으로 자신의 모든 데이터를 동적으로 계산하고 관리하는 '스마트 캐릭터'
extends Resource
class_name CharacterResource

## --- 기본 데이터 (CSV나 생성기에서 설정) ---
@export var character_name: String = "이름 없음"
@export var base_attributes: Dictionary = { "힘": 3, "민첩": 3, "건강": 3, "의지": 3, "영감": 3, "교육": 3, "매력": 3, "행운": 3 }
@export var skills: Dictionary = {} # 예: {"dodging": "trained"}
@export var wallet: Dictionary = {}

## --- 파생 능력치 (자동으로 계산될 변수들) ---
var max_hp: int = 0
var current_hp: int = 0
var max_sanity: int = 0
var current_sanity: int = 0
var physical_defense: int = 0
var will_defense: int = 0
var movement: int = 0

## --- 소지품 및 상태 ---
var inventory: Inventory
var statuses: Array[String] = []

# 캐릭터 리소스가 처음 생성될 때 호출되는 함수
func _init():
	# 캐릭터가 생성될 때, 자신의 전용 인벤토리 관리자를 고용합니다.
	inventory = Inventory.new(self)

# 캐릭터의 모든 파생 능력치를 Rulebook을 참조하여 '스스로' 재계산하는 핵심 함수
func calculate_all_derived_stats():
	# 속성 값들을 미리 가져옵니다.
	var health = base_attributes.get("건강", 0)
	var will = base_attributes.get("의지", 0)
	var agility = base_attributes.get("민첩", 0)
	var strength = base_attributes.get("힘", 0)

	# Rulebook 전문가에게 물어봐서 능력치를 계산합니다.
	max_hp = health + 10 # (formula: "health + 10")
	current_hp = max_hp
	
	max_sanity = will + 10 # (formula: "will + 10")
	current_sanity = max_sanity
	
	var dodging_rank = skills.get("dodging", "untrained") # 규칙서에 따라 '회피'는 'dodging' ID를 사용한다고 가정
	var dodging_bonus = Rulebook.get_skill_bonus(dodging_rank)
	# TODO: armor_bonus는 나중에 장착한 갑옷 아이템에서 가져와야 합니다. 지금은 0으로 고정.
	physical_defense = 10 + agility + 0 + dodging_bonus # (formula: "10 + agility + armor_bonus + dodging_skill_value")
	
	will_defense = 10 + will # (formula: "10 + will")
	movement = strength + agility # (formula: "strength + agility")
	
	print("'%s'의 능력치가 재계산되었습니다: HP=%d, 물리방어=%d" % [character_name, max_hp, physical_defense])
