# res://scenes/Main.gd
# 게임의 전체 흐름을 지휘하고 UI와 모든 전문가(싱글톤)를 연결하는 총괄 감독입니다.
extends Control

@onready var main_menu = $MainMenu
@onready var game_screen = $GameScreen
@onready var status_label = $GameScreen/VBoxContainer/StatusLabel
@onready var log_label = $GameScreen/VBoxContainer/LogLabel
@onready var new_game_button = $MainMenu/VBoxContainer/NewGameButton
@onready var quit_button = $MainMenu/VBoxContainer/QuitButton
@onready var next_turn_button = $GameScreen/VBoxContainer/NextTurnButton

var turn_index = -1

func _ready():
	# 버튼 시그널 연결
	new_game_button.pressed.connect(_on_new_game_pressed)
	quit_button.pressed.connect(get_tree().quit)
	next_turn_button.pressed.connect(_on_next_turn_pressed)

	# 초기 UI 상태 설정
	main_menu.show()
	game_screen.hide()

func _on_new_game_pressed():
	# --- 1. 캐릭터 생성 ---
	var player = CharacterResource.new()
	player.character_name = "플레이어"
	player.base_attributes = { "힘": 4, "민첩": 5, "건강": 5, "의지": 6, "영감": 6, "교육": 3, "매력": 3, "행운": 3 }
	player.skills = {"melee_brawling": "trained", "dodging": "trained"}
	player.calculate_all_derived_stats()

	var enemy = CharacterResource.new()
	enemy.character_name = "그림자 괴물"
	enemy.base_attributes = { "힘": 6, "민첩": 2, "건강": 8, "의지": 3, "영감": 3, "교육": 1, "매력": 1, "행운": 1 }
	enemy.skills = {"melee_brawling": "proficient", "dodging": "untrained"}
	enemy.calculate_all_derived_stats()

	# --- 2. 전투 시작 ---
	main_menu.hide()
	game_screen.show()
	log_label.clear()
	
	CombatManager.start_combat([player, enemy])
	log_label.append_text("===============⚔️ 전투 시작 ⚔️===============")
	turn_index = -1 # 턴 인덱스 초기화
	_on_next_turn_pressed() # 첫 턴 바로 진행

func _on_next_turn_pressed():
	if not CombatManager.is_combat_active:
		return

	# --- 3. 턴 진행 ---
	turn_index = (turn_index + 1) % CombatManager.turn_order.size()
	var current_actor = CombatManager.turn_order[turn_index]
	
	if current_actor.current_hp <= 0: # 이미 쓰러진 캐릭터는 턴 스킵
		_on_next_turn_pressed()
		return

	log_label.append_text("\n--- %s의 턴 ---" % current_actor.character_name)

	# 임시 AI: 플레이어가 아니면 자동으로 플레이어를 공격
	var target = null
	for char in CombatManager.combatants:
		if char != current_actor:
			target = char
			break
	
	if target and target.current_hp > 0:
		var result = RulesEngine.resolve_action(current_actor, "melee_brawling", target)
		log_label.append_text("  " + result.log)
		if result.hit:
			log_label.append_text("  [color=green]명중![/color] %d의 피해!" % result.damage)
			target.current_hp -= result.damage
		else:
			log_label.append_text("  [color=red]빗나감.[/color]")
	
	_update_status_display()

	# --- 4. 전투 종료 확인 ---
	if CombatManager.is_combat_over():
		var winner = ""
		for char in CombatManager.combatants:
			if char.current_hp > 0:
				winner = char.character_name
				break
		log_label.append_text("\n===============⚔️ 전투 종료 ⚔️===============\n승자: %s!" % winner)
		next_turn_button.text = "메인 메뉴로"
		CombatManager.is_combat_active = false
	elif next_turn_button.text == "메인 메뉴로": # 전투 종료 후 버튼 클릭 시
		main_menu.show()
		game_screen.hide()
		next_turn_button.text = "다음 턴 진행"


func _update_status_display():
	var text = ""
	for char in CombatManager.combatants:
		text += "%s (HP: %d/%d) | " % [char.character_name, char.current_hp, char.max_hp]
	status_label.text = text
