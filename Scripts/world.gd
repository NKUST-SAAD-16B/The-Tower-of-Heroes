extends Node2D


#房間路徑，用於隨機生成房間，需在編輯器中設置
@export var room_paths : Array[PackedScene] = []
#玩家UI場景
@onready var PlayerUI: PlayerGameUI = $CanvasLayer/Player_UI

#敵人場景，用於隨機生成敵人，需在編輯器中設置
@export var enemy_scene : Array[PackedScene] = []

#敵人生成數量，根據GameManager的enemy_spawn_quantity和DestinyManager的enemy_quantity_multiplier進行修改
@onready var enemy_spawn_quantity : int 


#商店菜單節點
@onready var ShopMenu : Control = $CanvasLayer/NewShopMenu

func _ready() -> void:
	#房間過渡，並生成第一個房間
	room_transition()
	#連接GameManager的enemy_defeated信號到transform_to_shop函數，當敵人被擊敗時觸發商店過渡
	GameManager.enemy_defeated.connect(transform_to_shop)
	#連接商店菜單的card_selected信號到scence_transition函數，當玩家選擇命運卡後觸發房間過渡
	ShopMenu.card_selected.connect(room_transition)
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
	
	#每次房間過渡時增加樓層數
	GameManager.current_floor += 1

	#在房間中生成玩家角色，位置為房間中名為"PlayerSpawn"的節點位置
	spawn_player(room_instance.get_node("PlayerSpawn").global_position)
	#根據DestinyManager的enemy_quantity_multiplier修改敵人生成數量
	enemy_spawn_quantity = int(GameManager.enemy_spawn_quantity * (1 + DestinyManager.enemy_quantity_multiplier))
	GameManager.enemy_spawn_quantity = enemy_spawn_quantity
	
	await SceneChanger.fade_in()
	
	#啟動敵人生成計時器
	get_node("EnemySpawnTimer").start()
	

#生成玩家角色
func spawn_player(player_position: Vector2) -> void:
	#實例化玩家角色並添加到當前房間
	var player_instance = GameManager.player_scene.instantiate()
	get_node("CurrentRoom").add_child(player_instance)
	player_instance.position = player_position
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
	var enemy = enemy_scene.pick_random().instantiate()
	#將生成的敵人添加到當前房間
	get_node("CurrentRoom").add_child(enemy)
	#將生成的敵人位置設置為選擇的生成點位置
	enemy.position = spawn_point.global_position


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
	#商店出現動畫，畫面由上方滑入，持續時間為1秒
	var tween := create_tween()
	#設置tween的暫停模式為Process，確保在遊戲暫停時仍然運行
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	get_tree().paused = true

	#將商店菜單初始位置設置在畫面上方，然後滑入到正常位置
	ShopMenu.position = Vector2(ShopMenu.position.x, -ShopMenu.size.y)
	ShopMenu.show()
	#使用tween來實現商店菜單的滑入動畫
	tween.tween_property(ShopMenu, "position", Vector2(ShopMenu.position.x, 0), 1.0)
	
