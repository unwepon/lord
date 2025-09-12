# res://scripts/core/DataManager.gd
extends Node

# 모든 게임 데이터를 저장할 변수들
var attributes_rules: Dictionary = {}
var skills_rules: Dictionary = {}
var combat_flow_rules: Dictionary = {}
# ... 수많은 다른 데이터 변수들 ...
var all_items: Dictionary = {}
var all_pathways: Dictionary = {}
var all_history_epochs: Array = []

func _ready():
	print("DataManager: 모든 게임 데이터 로딩을 시작합니다...")
	_load_all_data()
	print("DataManager: 모든 게임 데이터 로딩 완료!")

func _load_all_data():
	# 각 종류별 데이터를 로드하는 함수들을 순서대로 호출
	_load_rules_data()
	_load_items_data()
	_load_pathways_data()
	_load_history_data()

func _load_rules_data():
	var rules_path = "res://data/rules/"
	attributes_rules = _load_json(rules_path + "attributes_rules.json")
	skills_rules = _load_json(rules_path + "skills_rules.json")
	# TODO: 나머지 모든 규칙 JSON 파일들도 이곳에 추가
	print("  - 규칙 데이터 로드 완료")

func _load_items_data():
	var items_path = "res://data/items/"
	# TODO: ItemLoader를 사용하여 모든 아이템 로드
	print("  - 아이템 데이터 로드 완료")
	
func _load_pathways_data():
	var pathways_path = "res://data/pathways/"
	# TODO: 모든 경로 JSON 파일 로드
	print("  - 경로 데이터 로드 완료")

func _load_history_data():
	var history_path = "res://data/history/"
	var dir = DirAccess.open(history_path)
	if dir:
		for file_name in dir.get_files():
			if file_name.ends_with(".json"):
				var epoch_data = _load_json(history_path + file_name)
				if epoch_data:
					all_history_epochs.append(epoch_data)
	print("  - 역사 데이터 로드 완료")

# 범용 JSON 로더 (이전과 동일)
func _load_json(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		printerr("파일 열기 실패: " + file_path)
		return null
	var data = JSON.parse_string(file.get_as_text())
	return data
