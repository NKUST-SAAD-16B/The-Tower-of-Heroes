extends Node2D
class_name World

#房間路徑，用於隨機生成房間，需在編輯器中設置
@export var room_paths : Array[PackedScene] = []
#玩家UI場景
@onready var PlayerUI : PlayerGameUI = $CanvasLayer/Player_UI

#敵人場景，用於隨機生成敵人，需在編輯器中設置
@export var enemy_scene : Array[PackedScene] = []

#boss場景
@export var boss_scene : Array[PackedScene] = []


#敵人生成數量，根據GameManager的enemy_spawn_quantity和DestinyManager的enemy_quantity_multiplier進行修改
@onready var enemy_spawn_quantity : int 


#商店菜單節點
@onready var ShopMenu : Control = $CanvasLayer/NewShopMenu

#技能樹菜單節點
@onready var SkillTree : Control = $CanvasLayer/SkillTree

#確認是否是從存檔載入遊戲，如果是則不在_ready()中呼叫room_transition()
@onready var load_flag : bool = false

func _ready() -> void:
	AudioManager.play_bgm("dungeon")
	#如果不是從存檔載入遊戲，則呼叫room_transition()生成第一個房間
	if GameManager.is_loading_from_save:
		GameManager.is_loading_from_save = false # 重置載入標記，確保後續正常過渡
	else:
		room_transition()

	#連接GameManager的enemy_defeated信號到transform_to_shop函數，當敵人被擊敗時觸發商店過渡
	GameManager.enemy_defeated.connect(transform_to_shop)
	#連接商店菜單的card_selected信號到scence_transition函數，當玩家選擇命運卡後觸發房間過渡
	ShopMenu.card_selected.connect(transform_to_skill_tree)
	#連接技能樹的continue_to_next_floor信號到room_transition函數，當玩家在技能樹界面點擊繼續前往下一層按鈕後觸發房間過渡
	SkillTree.continue_to_next_floor.connect(room_transition)
	#連接GameManager的remaining_enemy_spawn_quantity_found信號到_on_required_enemy_spawn_quantity函數，當讀檔時發現還有剩餘敵人生成數量，繼續生成敵人
	GameManager.remaining_enemy_spawn_quantity_found.connect(_on_required_enemy_spawn_quantity)
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		PauseGame()
	pass

#房間過渡，生成新房間
func room_transition():

	await SceneChanger.fade_out()
	
	#如果當前房間中有子節點，則刪除它們以清空房間
	if get_node("CurrentRoom").get_child_count() > 0:
		for child in get_node("CurrentRoom").get_children():
			child.queue_free()

	#隨機選擇一個房間場景並實例化
	var current_scene = room_paths.pick_random()
	var room_scene = load(current_scene.resource_path)
	var room_instance = room_scene.instantiate()
	get_node("CurrentRoom").add_child(room_instance)
	
	#每次房間過渡時增加樓層數及提升敵人屬性修飾
	GameManager.current_floor += 1
	GameManager.enemy_damage_multiplier += 0.1
	GameManager.enemy_health_multiplier += 0.1
	GameManager.enemy_walk_speed_multiplier += 0.1
	GameManager.enemy_quantity_multiplier += 0.03 #改成0.03，原本的我發現第十一層就破百了XD



	
	#設定敵人生成數量，根據GameManager的enemy_spawn_quantity和敵人的enemy_quantity_multiplier進行修改
	GameManager.enemy_spawn_quantity = int(GameManager.enemy_spawn_quantity * GameManager.enemy_quantity_multiplier)
	GameManager.current_enemy_quantity = GameManager.enemy_spawn_quantity
	enemy_spawn_quantity = GameManager.enemy_spawn_quantity
	
	#生成上限，確保敵人生成數量不會過多導致遊戲體驗不佳
	if enemy_spawn_quantity > 30:
		enemy_spawn_quantity = 30
		GameManager.current_enemy_quantity = 30
		GameManager.enemy_spawn_quantity = 30
		print("敵人生成數量已達上限，設置為30")

	#如果層數是10的倍數，則是boss關
	if GameManager.current_floor % 10 == 0:
		boss()
	
	#在房間中生成玩家角色，位置為房間中名為"PlayerSpawn"的節點位置
	spawn_player(room_instance.get_node("PlayerSpawn").global_position)
	await SceneChanger.fade_in()
	


	#啟動敵人生成計時器
	get_node("EnemySpawnTimer").start()

#生成玩家角色
func spawn_player(player_position: Vector2) -> void:
	#實例化玩家角色並添加到當前房間
	var player_instance = GameManager.player_scene.instantiate()
	get_node("CurrentRoom").add_child(player_instance)
	if not player_instance.is_node_ready():
		await player_instance.ready #等待玩家角色的_ready()函數執行完畢，確保玩家角色的節點和組件都已經初始化完成
	
	player_instance.position = player_position
	print("玩家生成於位置: ", player_position)
	#設置玩家UI的HealthComponent引用
	PlayerUI.health_component = player_instance.health_component
	PlayerUI.setup_ui()
	pass


#暫停遊戲
func PauseGame():
	print("遊戲暫停")
	get_tree().paused = true
	get_node("CanvasLayer/PauseMenu").show()

#隨機生成敵人
func EnemySpawn():
	#從所有敵人生成點中隨機選擇一個，並在該位置生成一個敵人
	var all_points = get_tree().get_nodes_in_group("EnemySpawnPoints")
	#從enemy_scene中隨機選擇一個敵人場景並實例化
	var spawn_point = all_points.pick_random()
	var enemy
	#如果層數是10的倍數，則生成boss，否則生成普通敵人
	if GameManager.current_floor % 10 == 0:
		enemy = boss_scene.pick_random().instantiate()
	else:
		enemy = enemy_scene.pick_random().instantiate()
	#將生成的敵人添加到當前房間
	get_node("CurrentRoom").add_child(enemy)
	#將敵人加入群組"Enemies"，以便後續管理
	enemy.add_to_group("Enemies")
	#將生成的敵人位置設置為選擇的生成點位置
	enemy.position = spawn_point.global_position

#讀檔時發現還有剩餘敵人生成數量，繼續生成敵人
func _on_required_enemy_spawn_quantity(quantity: int):
	enemy_spawn_quantity = quantity
	get_node("EnemySpawnTimer").start()
	pass

#敵人生成計時器觸發時生成敵人
func _on_enemy_spawn_timer_timeout() -> void:
	EnemySpawn()
	enemy_spawn_quantity -= 1
	print("生成敵人，剩餘生成數量: " + str(enemy_spawn_quantity))
	#當敵人生成數量小於等於0時停止生成敵人
	if enemy_spawn_quantity <= 0:
		get_node("EnemySpawnTimer").stop()
		print("敵人全部生成完畢")
	


#商店過渡，生成商店菜單
func transform_to_shop():
	await get_tree().process_frame#等待當前幀結束，確保所有敵人死亡後的邏輯都已經處理完畢
	#等待場景中的金幣都被刪除
	while get_tree().get_nodes_in_group("Golds").size() > 0:
		print("等待金幣被撿取或消失，剩餘金幣數量: ", get_tree().get_nodes_in_group("Golds").size())
		await get_tree().process_frame
	# 稍微等待一下，確保最後一個怪物的死亡動畫能完全播完
	await get_tree().create_timer(1.0).timeout
	
	#商店出現動畫，畫面由上方滑入，持續時間為1秒
	var tween := create_tween()
	#設置tween的暫停模式為Process，確保在遊戲暫停時仍然運行
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	get_tree().paused = true

	#將商店菜單初始位置設置在畫面上方，然後滑入到正常位置
	ShopMenu.position = Vector2(ShopMenu.position.x, -ShopMenu.size.y)
	if ShopMenu.has_method("generate_cards"):
		ShopMenu.generate_cards()
	ShopMenu.show()
	#使用tween來實現商店菜單的滑入動畫
	tween.tween_property(ShopMenu, "position", Vector2(ShopMenu.position.x, 0), 1.0)

#切換到技能樹界面
func transform_to_skill_tree():
	#技能樹界面出現動畫，畫面由上方滑入，持續時間為1秒
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	SkillTree.position = Vector2(SkillTree.position.x, -SkillTree.size.y)
	SkillTree.show()
	tween.tween_property(SkillTree, "position", Vector2(SkillTree.position.x, 0), 1.0)
	pass

func boss():
	print("進入Boss房")
	#當前敵人數量為1人，生成Boss
	enemy_spawn_quantity = 1
	GameManager.current_enemy_quantity = 1
	