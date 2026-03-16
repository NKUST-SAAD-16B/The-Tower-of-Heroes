extends Node

# 命運管理器，全域腳本，負責生成和應用命運卡的效果

var destiny_counts = {
	"Enemy_damage_reduction": 0,    # 光明的庇護
	"Enemy_health_reduction": 0,    # 光之鎖
	"Enemy_damage_increase": 0,     # 黑暗詛咒
	"Enemy_health_increase": 0,     # 惡魔的詠唱
	"Enemy_speed_increase": 0,      # 暗影的加速
	"Enemy_quantity_increase": 0,   # 怪物奉上
	"Player_damage_increase": 0,    # 戰神的祝福
	"Player_health_increase": 0     # 女神的庇護
}

var destiny_data = {
	"Enemy_damage_increase": {
		"title": "黑暗詛咒",
		"icon": "res://path_to_destiny_1_icon.png",
		"description": "敵人的傷害增加10%",

	},
	"Enemy_health_increase": {
		"title": "惡魔的詠唱",
		"icon": "res://path_to_destiny_2_icon.png",
		"description": "敵人的生命增加10%"
	},
	"Player_damage_increase": {
		"title": "戰神的祝福",
		"icon": "res://path_to_destiny_3_icon.png",
		"description": "玩家的傷害增加20"
	},
	"Player_health_increase": {
		"title": "女神的庇護",
		"icon": "res://path_to_destiny_4_icon.png",
		"description": "玩家的最大生命增加20"
	},
	"Enemy_damage_reduction": {
		"title": "光明的庇護",
		"icon": "res://path_to_destiny_5_icon.png",
		"description": "敵人的傷害減少10%"
	},
	"Enemy_health_reduction": {
		"title": "光之鎖",
		"icon": "res://path_to_destiny_6_icon.png",
		"description": "敵人的生命減少10%"
	},
	"Enemy_speed_increase": {
		"title": "暗影的加速",
		"icon": "res://path_to_destiny_7_icon.png",
		"description": "敵人的移動速度增加10%"
	},
	"Enemy_quantity_increase": {
		"title": "怪物奉上",
		"icon": "res://path_to_destiny_8_icon.png",
		"description": "敵人數量增加10%"
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
			# 玩家增益類與特定敵人類上限為 5 次
			var five_limit_keys = [
				"Player_damage_increase", 
				"Player_health_increase",
				"Enemy_damage_increase",
				"Enemy_speed_increase",
				"Enemy_quantity_increase"
			]
			
			if key in five_limit_keys:
				max_count = 5
				
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
	if destiny_counts.has(random_key):
		var level = destiny_counts[random_key] + 1
		result["title"] = result["title"] + " " + get_roman_numeral(level)
		
		# 動態更新敘述中的數值
		if "Player" in random_key:
			# 玩家類：20 -> 40 -> 60 -> 80 -> 100
			var new_val = str(level * 20)
			result["description"] = result["description"].replace("20", new_val)
		else:
			# 敵人類：10% -> 20% -> 30%
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
			# 增加敵人傷害10%
			GameManager.enemy_damage_multiplier += 0.1
		"Enemy_health_increase":
			# 增加敵人生命10%
			GameManager.enemy_health_multiplier += 0.1
		"Enemy_speed_increase":
			# 增加敵人移動速度10%
			GameManager.enemy_walk_speed_multiplier += 0.1
		"Enemy_quantity_increase":
			# 增加敵人數量10%
			GameManager.enemy_quantity_multiplier += 0.1
		"Player_damage_increase":
			# 增加玩家傷害20
			PlayerData.player_base_damage += 20
		"Player_health_increase":
			# 增加玩家最大生命20
			PlayerData.player_max_health += 20
		"Enemy_damage_reduction":
			# 減少敵人傷害10%
			GameManager.enemy_damage_multiplier -= 0.1
		"Enemy_health_reduction":
			# 減少敵人生命10%
			GameManager.enemy_health_multiplier -= 0.1
