extends Node

# 命運管理器，全域腳本，負責生成和應用命運卡的效果

var destiny_counts = {
	"Enemy_damage_reduction": 0,    # 光明的庇護 (3)
	"Enemy_health_reduction": 0,    # 光之鎖 (3)
	"Enemy_damage_increase": 0,     # 黑暗詛咒 (5)
	"Enemy_health_increase": 0,     # 惡魔的詠唱 (3)
	"Enemy_speed_increase": 0,      # 暗影的加速 (5)
	"Enemy_quantity_increase": 0,   # 怪物奉上 (5)
	"Player_damage_increase": 0,    # 戰神的祝福 (5)
	"Player_health_increase": 0,    # 女神的庇護 (5)
	"Guardian_Fake_Shield": 0,      # 守護者偽盾 (5)
	"Scarlet_Festival": 0,          # 腥紅盛典 (5)
	"Resource_drop_increase": 0     # 卑鄙原之助 (5)
}

var destiny_data = {
	"Enemy_damage_increase": {
		"title": "彷彿被注視著",
		"icon": "res://Assets/Icons/icon29.png",
		"description": "敵人的傷害增加10%",
	},
	"Enemy_health_increase": {
		"title": "惡魔的詠唱",
		"icon": "res://Assets/Icons/icon11.png",
		"description": "敵人的生命增加10%"
	},
	"Player_damage_increase": {
		"title": "戰神的祝福",
		"icon": "res://Assets/Icons/icon26.png",
		"description": "玩家的傷害增加20"
	},
	"Player_health_increase": {
		"title": "女神的庇護",
		"icon": "res://Assets/Icons/icon7.png",
		"description": "玩家的最大生命增加20"
	},
	"Enemy_damage_reduction": {
		"title": "光明的庇護",
		"icon": "res://Assets/Icons/icon6.png",
		"description": "敵人的傷害減少10%"
	},
	"Enemy_health_reduction": {
		"title": "聖之鑰匙",
		"icon": "res://Assets/Icons/icon19.png",
		"description": "敵人的生命減少10%"
	},
	"Enemy_speed_increase": {
		"title": "黑魔法靈藥",
		"icon": "res://Assets/Icons/icon3.png",
		"description": "敵人的移動速度增加10%"
	},
	"Enemy_quantity_increase": {
		"title": "未知卷軸",
		"icon": "res://Assets/Icons/icon24.png",
		"description": "敵人數量增加10%"
	},
	"Guardian_Fake_Shield": {
		"title": "守護龜殼",
		"icon": "res://Assets/Icons/icon30.png",
		"description": "玩家獲得50點護盾值"
	},
	"Scarlet_Festival": {
		"title": "奇怪的果實",
		"icon": "res://Assets/Icons/icon31.png",
		"description": "玩家的傷害增加50，但扣除20點當前生命"
	},
	"Resource_drop_increase": {
		"title": "卑鄙原之助",
		"icon": "res://Assets/Icons/icon20.png",
		"description": "金幣掉落量增加15%"
	}
}

func get_roman_numeral(n: int) -> String:
	match n:
		1: return "I"
		2: return "II"
		3: return "III"
		4: return "IV"
		5: return "V"
		_: return str(n)

func destiny_random(exclude_keys: Array = []) -> Dictionary: 
	var available_keys = []
	for key in destiny_data.keys():
		# 排除已經被選入本次商店的 Key
		if key in exclude_keys:
			continue
			
		# 檢查是否有次數限制
		if destiny_counts.has(key):
			var max_count = 3
			# 設定上限為 5 次的 Key 清單
			var five_limit_keys = [
				"Player_damage_increase", 
				"Player_health_increase",
				"Enemy_damage_increase",
				"Enemy_speed_increase",
				"Enemy_quantity_increase",
				"Guardian_Fake_Shield",
				"Scarlet_Festival"
			]
			
			if key in five_limit_keys:
				max_count = 5
			elif key == "Resource_drop_increase":
				max_count = 1
				
			if destiny_counts[key] < max_count:
				available_keys.append(key)
		else:
			available_keys.append(key)
			
	if available_keys.is_empty():
		return {}
			
	var random_key = available_keys.pick_random()
	var result = destiny_data[random_key].duplicate()
	result["key"] = random_key # 加入 key 以便後續識別
	
	# 如果是有次數限制的事件，加上羅馬數字標記並更新敘述
	if destiny_counts.has(random_key) and random_key != "Resource_drop_increase":
		var level = destiny_counts[random_key] + 1
		result["title"] = result["title"] + " " + get_roman_numeral(level)
		
		# 動態更新敘述中的數值
		if "Player" in random_key or "Guardian" in random_key or "Scarlet" in random_key:
			# 玩家類/特殊類數值替換
			if "20" in result["description"]:
				result["description"] = result["description"].replace("20", str(level * 20))
			if "50" in result["description"]:
				result["description"] = result["description"].replace("50", str(level * 50))
		else:
			# 敵人類：10% -> 20% -> 30% -> 40% -> 50%
			if "10%" in result["description"]:
				var new_percent = str(level * 10) + "%"
				result["description"] = result["description"].replace("10%", new_percent)
		
	return result


# 根據命運卡的標題應用對應的效果
func destiny_apply(destiny: Dictionary) -> void:
	var key = destiny.get("key", "")
	print("Applying destiny: " + destiny["title"] + " (Key: " + key + ")")
	
	# 如果該 key 有計數器，則增加計數
	if destiny_counts.has(key):
		destiny_counts[key] += 1
		print(destiny["title"] + " 已選擇 " + str(destiny_counts[key]) + " 次")

	match key:
		"Enemy_damage_increase":
			GameManager.enemy_damage_multiplier += 0.1
		"Enemy_health_increase":
			GameManager.enemy_health_multiplier += 0.1
		"Enemy_speed_increase":
			GameManager.enemy_walk_speed_multiplier += 0.1
		"Enemy_quantity_increase":
			GameManager.enemy_quantity_multiplier += 0.1
		"Player_damage_increase":
			PlayerData.player_base_damage += 20
		"Player_health_increase":
			PlayerData.player_max_health += 20
			PlayerData.player_current_health += 20 # 同時回復當前生命
		"Enemy_damage_reduction":
			GameManager.enemy_damage_multiplier -= 0.1
		"Enemy_health_reduction":
			GameManager.enemy_health_multiplier -= 0.1
		"Guardian_Fake_Shield":
			# 賦予玩家 50 點護盾，用於抵擋傷害
			PlayerData.player_current_shield += 50
			print("玩家獲得 50 點護盾，當前護盾: " + str(PlayerData.player_current_shield))
		"Scarlet_Festival":
			PlayerData.player_base_damage += 50
			# 直接修改當前生命
			PlayerData.player_current_health -= 20
			# 確保生命不會低於 1
			if PlayerData.player_current_health < 1:
				PlayerData.player_current_health = 1
			print("腥紅盛典：增加傷害 50，扣除生命 20，當前生命: " + str(PlayerData.player_current_health))
		"Resource_drop_increase":
			GameManager.enemy_gold_multiplier += 0.15
			print("卑鄙原之助：金幣掉落倍率增加至 " + str(GameManager.enemy_gold_multiplier))
