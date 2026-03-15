extends Node


#玩家場景
var player_scene = preload("res://Scenes/Character/player.tscn")

signal enemy_defeated

#當前樓層數，初始值為1，每次房間過渡時增加1	
var current_floor : int = 0

#敵人生成數量，初始值為10，根據DestinyManager的enemy_quantity_multiplier進行修改
var enemy_spawn_quantity : int = 1:
	#當enemy_spawn_quantity被修改時，同步更新current_enemy_quantity的值，確保它們保持一致
	set(value):
		current_enemy_quantity = value
		enemy_spawn_quantity = value


#敵人屬性修飾
var enemy_damage_multiplier : float = 1.0
var enemy_health_multiplier : float = 1.0
var enemy_walk_speed_multiplier : float = 1.0
var enemy_quantity_multiplier : float = 1.0

#當前敵人數量
var current_enemy_quantity : int = enemy_spawn_quantity:
	set(value):
		current_enemy_quantity = value
		print("當前敵人數量: " + str(current_enemy_quantity))
		#當當前敵人數量小於等於0時觸發enemy_defeated信號，通知world.gd進行商店過渡
		if current_enemy_quantity <= 0:
			enemy_defeated.emit()

# 存檔檔案路徑
const SAVE_PATH = "user://savegame.save"

# 檢查是否有存檔
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# 儲存遊戲數據
func save_game():
	var save_data = {
		"game_manager": {
			"current_floor": current_floor,
			"enemy_damage_multiplier": enemy_damage_multiplier,
			"enemy_health_multiplier": enemy_health_multiplier,
			"enemy_walk_speed_multiplier": enemy_walk_speed_multiplier,
			"enemy_quantity_multiplier": enemy_quantity_multiplier
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
			"scale": PlayerData.player_scale
		}
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()
		print("遊戲已儲存至: ", SAVE_PATH)

# 讀取遊戲數據
func load_game():
	if not has_save_file():
		print("找不到存檔檔案！")
		return false
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.data
			
			# 還原 GameManager 數據
			var gm_data = save_data.get("game_manager", {})
			# 這裡減 1，因為 World.gd 的 room_transition 會自動加 1
			current_floor = gm_data.get("current_floor", 1) - 1
			enemy_damage_multiplier = gm_data.get("enemy_damage_multiplier", 1.0)
			enemy_health_multiplier = gm_data.get("enemy_health_multiplier", 1.0)
			enemy_walk_speed_multiplier = gm_data.get("enemy_walk_speed_multiplier", 1.0)
			enemy_quantity_multiplier = gm_data.get("enemy_quantity_multiplier", 1.0)
			
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
			
			print("存檔讀取成功！當前樓層準備還原為: ", current_floor + 1)
			# 讀取後切換到遊戲場景
			SceneChanger.change_scene("res://Scenes/World.tscn")
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
