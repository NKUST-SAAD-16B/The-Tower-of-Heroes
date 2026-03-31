extends Node


#玩家場景
var player_scene = preload("res://Scenes/Character/player.tscn")

var easter_egg_enabled : bool = false

var is_loading_from_save: bool = false # 用於標記是否正在從存檔載入遊戲，初始值為 false

signal enemy_defeated

signal enemy_quantity_changed

signal remaining_enemy_spawn_quantity_found # 讀檔時發現還有剩餘敵人生成數量，通知world.gd繼續生成敵人

#當前樓層數，初始值為1，每次房間過渡時增加1	
var current_floor : int = 0

#敵人生成數量，初始值為10，根據DestinyManager的enemy_quantity_multiplier進行修改

var enemy_spawn_quantity : int = 10

	#當enemy_spawn_quantity被修改時，同步更新current_enemy_quantity的值，確保它們保持一致
	#set(value):
		#current_enemy_quantity = value
		#enemy_spawn_quantity = value


#敵人屬性修飾
var enemy_damage_multiplier : float = 1.0
var enemy_health_multiplier : float = 1.0
var enemy_walk_speed_multiplier : float = 1.0
var enemy_quantity_multiplier : float = 1.0
var enemy_gold_multiplier : float = 1.0

#當前敵人數量
var current_enemy_quantity : int = enemy_spawn_quantity:
	set(value):
		current_enemy_quantity = value
		print("當前敵人數量: " + str(current_enemy_quantity))

		#發出敵人數量變化的信號，通知UI更新顯示
		enemy_quantity_changed.emit()

		#當當前敵人數量小於等於0時觸發enemy_defeated信號，通知world.gd進行商店過渡
		if current_enemy_quantity <= 0:
			enemy_defeated.emit()


# 存檔檔案路徑
const SAVE_PATH = "user://savegame.save"

func _ready() -> void:
	load_settings_only()

# 檢查是否有存檔
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# 儲存遊戲數據
func save_game():

	var world = get_tree().current_scene #獲取當前場景的根節點
	var current_room = world.get_node("CurrentRoom").get_child(0) #獲取CurrentRoom底下的第一個子節點，這個節點代表當前所在的房間
	#構建一個字典來保存遊戲數據，包括GameManager的狀態、玩家數據、當前房間信息、敵人數據和技能樹狀態等
	var save_data = {
		"game_manager": {
			"current_floor": current_floor,
			"enemy_damage_multiplier": enemy_damage_multiplier,
			"enemy_health_multiplier": enemy_health_multiplier,
			"enemy_walk_speed_multiplier": enemy_walk_speed_multiplier,
			"enemy_quantity_multiplier": enemy_quantity_multiplier,
			"current_enemy_quantity": current_enemy_quantity,
			"easter_egg_enabled": easter_egg_enabled
		},
		"player_data": {
			"current_health": PlayerData.player_current_health,
			"max_health": PlayerData.player_max_health,
			"base_damage": PlayerData.player_base_damage,
			"bonus_damage": PlayerData.player_bonus_damage,
			"critical_chance": PlayerData.player_critical_chance,
			"critical_multiplier": PlayerData.player_critical_multiplier,
			"walk_speed": PlayerData.player_walk_speed,
			"run_speed": PlayerData.player_run_speed,
			"scale": PlayerData.player_scale,
			"gold_quantity": PlayerData.gold_quantity,
			"player_current_shield": PlayerData.player_current_shield,
			"position.x":PlayerData.player_position_x,
			"position.y":PlayerData.player_position_y
		},
		"enemies": [],
		"world": {
			"current_room": current_room.scene_file_path,
			"remaining_enemy_spawn_quantity": world.enemy_spawn_quantity #剩餘敵人生成數量
		},
		"skill_tree": []
		
	}
	var enemies = get_tree().get_nodes_in_group("Enemies") #獲取當前場景中所有屬於"Enemies"群組的節點，這些節點代表當前存在的敵人
	#遍歷所有敵人，將它們的數據（如生命值、位置、類型等）保存到save_data的"enemies"列表中
	for enemy in enemies:
		var enemy_data = {
			"health": enemy.health_component.current_health,
			"position.x": enemy.position.x,
			"position.y": enemy.position.y,
			"type": enemy.scene_file_path, #透過路徑獲取敵人類型
		}
		save_data["enemies"].append(enemy_data)
	
	#將已解鎖的技能保存到save_data的"skill_tree"部分
	var skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	for button in skill_buttons:
		var skill_data = {
			"skill_name": button.skill_name,
			"button_state": button.button_state
		}
		save_data["skill_tree"].append(skill_data)

	#將save_data轉換為JSON字符串，並寫入到指定的存檔路徑中
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()
		print("遊戲已儲存至: ", SAVE_PATH)



# 僅讀取數據，不跳轉場景
func load_settings_only():
	if not has_save_file():
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.data
			var gm_data = save_data.get("game_manager", {})
			easter_egg_enabled = gm_data.get("easter_egg_enabled", false)
			print("系統設定已載入，彩蛋狀態: ", easter_egg_enabled)

# 讀取遊戲數據
func load_game():
	if not has_save_file():
		print("找不到存檔檔案！")
		return false
	
	is_loading_from_save = true # 標記正在從存檔載入遊戲
	await SceneChanger.fade_out()
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
	await get_tree().tree_changed # 等待新場景加載完成
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.data
			
			#還原房間
			var world = get_tree().current_scene
			var current_room = world.get_node("CurrentRoom")
			var room_scene = load(save_data["world"]["current_room"])
			var room_instance = room_scene.instantiate()
			current_room.add_child(room_instance)
			
			#如果還有剩餘的敵人生成數量，則啟動敵人生成計時器繼續生成敵人
			var remaining_enemy_spawn_quantity = save_data["world"].get("remaining_enemy_spawn_quantity", 0)
			if remaining_enemy_spawn_quantity > 0:
				enemy_spawn_quantity = remaining_enemy_spawn_quantity
				current_enemy_quantity = save_data["game_manager"].get("current_enemy_quantity") # 從存檔中還原當前敵人數量，如果沒有則使用enemy_spawn_quantity的值
				remaining_enemy_spawn_quantity_found.emit() # 發出信號通知world.gd繼續生成敵人
				print("發現剩餘敵人生成數量: ", remaining_enemy_spawn_quantity, "，繼續生成敵人中...")
			else:
				print("沒有剩餘敵人生成數量，當前房間內的敵人將保持不變。")
				
			# 還原 GameManager 數據
			var gm_data = save_data.get("game_manager", {})
			# 這裡減 1，因為 World.gd 的 room_transition 會自動加 1
			current_floor = gm_data.get("current_floor", 1)
			enemy_damage_multiplier = gm_data.get("enemy_damage_multiplier", 1.0)
			enemy_health_multiplier = gm_data.get("enemy_health_multiplier", 1.0)
			enemy_walk_speed_multiplier = gm_data.get("enemy_walk_speed_multiplier", 1.0)
			enemy_quantity_multiplier = gm_data.get("enemy_quantity_multiplier", 1.0)
			easter_egg_enabled = gm_data.get("easter_egg_enabled", false)
			
			# 還原技能樹狀態
			var skill_tree_dict = {} # 用於存儲技能名稱和按鈕狀態的字典
			for skill_data in save_data.get("skill_tree", []):
				skill_tree_dict[skill_data["skill_name"]] = skill_data["button_state"] # 將技能名稱和按鈕狀態存入字典
			var skill_tree_button = get_tree().get_nodes_in_group("skill_buttons") # 獲取當前場景中所有屬於"skill_buttons"群組的節點，這些節點代表技能樹中的按鈕
			var skill_tree_instance = world.get_node("CanvasLayer/SkillTree") # 獲取技能樹實例
			for button in skill_tree_button: #遍歷所有技能按鈕
				if skill_tree_dict[button.skill_name]: #如果技能名稱在字典中且按鈕狀態為true，則啟用該按鈕
					button.disabled = true
					button.button_state = true
					skill_tree_instance.enable_next_button(button) #啟用下一個按鈕



			# 還原 PlayerData 數據
			var pd_data = save_data.get("player_data", {})
			PlayerData.player_current_health = pd_data.get("current_health", 100)
			PlayerData.player_max_health = pd_data.get("max_health", 100)
			PlayerData.player_base_damage = pd_data.get("base_damage", 50)
			PlayerData.player_bonus_damage = pd_data.get("bonus_damage", 0)
			PlayerData.player_critical_chance = pd_data.get("critical_chance", 0.0)
			PlayerData.player_critical_multiplier = pd_data.get("critical_multiplier", 1.5)
			PlayerData.player_walk_speed = pd_data.get("walk_speed", 50)
			PlayerData.player_run_speed = pd_data.get("run_speed", 100)
			PlayerData.player_scale = pd_data.get("scale", 0.6)
			PlayerData.player_position_x = pd_data.get("position.x", 0)
			PlayerData.player_position_y = pd_data.get("position.y", 0)
			world.spawn_player(Vector2(PlayerData.player_position_x, PlayerData.player_position_y))
			
			# 還原敵人數據
			for enemy_data in save_data["enemies"]:
				var enemy_scene = load(enemy_data["type"])
				
				if enemy_scene:
					var enemy_instance = enemy_scene.instantiate()
					current_room.add_child(enemy_instance)
					#等待敵人實例的_ready()函數執行完畢，確保敵人節點和組件都已經初始化完成	
					if not enemy_instance.is_node_ready():
						await enemy_instance.ready
					
					enemy_instance.position = Vector2(enemy_data["position.x"], enemy_data["position.y"])
					enemy_instance.health_component.current_health = enemy_data["health"]
					enemy_instance.add_to_group("Enemies") 
			
			print("存檔讀取成功！當前樓層準備還原為: ", current_floor )
			# 讀取後切換到遊戲場景
			await SceneChanger.fade_in()
			return true
	return false

#開始新遊戲
func start_new_game():
	# 初始化玩家數據
	PlayerData.player_data_init()
	# 設為 0，因為 World.gd 的 room_transition 會自動加 1
	current_floor = 0
	# 重置其他遊戲倍率
	enemy_damage_multiplier = 1.0
	enemy_health_multiplier = 1.0
	enemy_walk_speed_multiplier = 1.0
	enemy_quantity_multiplier = 1.0
	
	# 切換到遊戲場景
	print("開始新遊戲，切換到遊戲場景")
	SceneChanger.change_scene("res://Scenes/World.tscn")
