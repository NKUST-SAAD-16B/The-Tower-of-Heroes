extends Node

# 命運管理器，全域腳本，負責生成和應用命運卡的效果

var destiny_counts = {
	"Enemy_damage_reduction": 0,
	"Enemy_health_reduction": 0,
	"Enemy_damage_increase": 0,
	"Enemy_health_increase": 0,
	"Enemy_speed_increase": 0,
	"Enemy_quantity_increase": 0,
	"Player_damage_increase": 0,
	"Player_health_increase": 0,
	"Guardian_Fake_Shield": 0,
	"Scarlet_Festival": 0,
	"Resource_drop_increase": 0
}

# 命運資料定義：新增命運時，優先只改這裡
var destiny_definitions = {
	"Enemy_damage_increase": {
		"title": "彷彿被注視著",
		"icon": "res://Assets/Icons/icon29.png",
		"description_template": "敵人的傷害增加{v1}%",
		"description_values": [10],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_damage_multiplier", "op": "add", "amount": 0.1}
		]
	},
	"Enemy_health_increase": {
		"title": "惡魔的詠唱",
		"icon": "res://Assets/Icons/icon11.png",
		"description_template": "敵人的生命增加{v1}%",
		"description_values": [10],
		"max_count": 3,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_health_multiplier", "op": "add", "amount": 0.1}
		]
	},
	"Player_damage_increase": {
		"title": "戰神的祝福",
		"icon": "res://Assets/Icons/icon26.png",
		"description_template": "玩家的傷害增加{v1}",
		"description_values": [20],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "player", "stat": "player_base_damage", "op": "add", "amount": 20}
		]
	},
	"Player_health_increase": {
		"title": "女神的庇護",
		"icon": "res://Assets/Icons/icon7.png",
		"description_template": "玩家的最大生命增加{v1}",
		"description_values": [20],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "player", "stat": "player_max_health", "op": "add", "amount": 20},
			{"target": "player", "stat": "player_current_health", "op": "add", "amount": 20}
		]
	},
	"Enemy_damage_reduction": {
		"title": "光明的庇護",
		"icon": "res://Assets/Icons/icon6.png",
		"description_template": "敵人的傷害減少{v1}%",
		"description_values": [10],
		"max_count": 3,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_damage_multiplier", "op": "add", "amount": -0.1}
		]
	},
	"Enemy_health_reduction": {
		"title": "聖之鑰匙",
		"icon": "res://Assets/Icons/icon19.png",
		"description_template": "敵人的生命減少{v1}%",
		"description_values": [10],
		"max_count": 3,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_health_multiplier", "op": "add", "amount": -0.1}
		]
	},
	"Enemy_speed_increase": {
		"title": "黑魔法靈藥",
		"icon": "res://Assets/Icons/icon3.png",
		"description_template": "敵人的移動速度增加{v1}%",
		"description_values": [10],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_walk_speed_multiplier", "op": "add", "amount": 0.1}
		]
	},
	"Enemy_quantity_increase": {
		"title": "未知卷軸",
		"icon": "res://Assets/Icons/icon24.png",
		"description_template": "敵人數量增加{v1}%",
		"description_values": [10],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "game", "stat": "enemy_quantity_multiplier", "op": "add", "amount": 0.1}
		]
	},
	"Guardian_Fake_Shield": {
		"title": "守護龜殼",
		"icon": "res://Assets/Icons/icon30.png",
		"description_template": "玩家獲得{v1}點護盾值",
		"description_values": [50],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "player", "stat": "player_current_shield", "op": "add", "amount": 50}
		]
	},
	"Scarlet_Festival": {
		"title": "奇怪的果實",
		"icon": "res://Assets/Icons/icon31.png",
		"description_template": "玩家的傷害增加{v1}，但扣除{v2}點當前生命",
		"description_values": [50, 20],
		"max_count": 5,
		"show_level_in_title": true,
		"scale_description_with_level": true,
		"effects": [
			{"target": "player", "stat": "player_base_damage", "op": "add", "amount": 50},
			{"target": "player", "stat": "player_current_health", "op": "add", "amount": -20, "min_value": 1}
		]
	},
	"Resource_drop_increase": {
		"title": "卑鄙原之助",
		"icon": "res://Assets/Icons/icon20.png",
		"description_template": "金幣掉落量增加{v1}%",
		"description_values": [15],
		"max_count": 1,
		"show_level_in_title": false,
		"scale_description_with_level": false,
		"effects": [
			{"target": "game", "stat": "enemy_gold_multiplier", "op": "add", "amount": 0.15}
		]
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

func _get_max_count(key: String) -> int: #根據命運卡的 key 返回其最大選擇次數，默認為 3 次
	var definition = destiny_definitions.get(key, {})
	return definition.get("max_count", 3)

func _build_description(definition: Dictionary, level: int) -> String: #根據命運卡的定義和當前等級構建描述文本，替換其中的 {v1}, {v2} 等占位符
	var description: String = definition.get("description_template", "") #獲取描述模板，默認為空字符串
	var base_values: Array = definition.get("description_values", []) #獲取描述中需要替換的基礎數值列表，默認為空數組
	var scale_with_level: bool = definition.get("scale_description_with_level", true) #獲取是否需要根據等級縮放描述數值的標誌，默認為 true
	var factor: int = level if scale_with_level else 1

	for i in range(base_values.size()): #對於每個需要替換的數值，計算其最終值並替換描述中的占位符
		var token = "{v" + str(i + 1) + "}" #占位符格式為 {v1}, {v2} 等
		var computed_value = int(base_values[i]) * factor #計算最終值，如果需要根據等級縮放，則乘以等級
		description = description.replace(token, str(computed_value)) #將占位符替換為計算出的最終值

	return description

func _resolve_target(target_name: String): #根據效果定義中的 target 字段返回對應的對象引用，目前支持 "game" 和 "player"
	match target_name:
		"game":
			return GameManager
		"player":
			return PlayerData
		_:
			return null

func _apply_effect(effect: Dictionary) -> void: #根據效果定義應用對應的效果
	var target = _resolve_target(effect.get("target", ""))
	if target == null:
		return

	var stat: String = effect.get("stat", "")
	if stat.is_empty():
		return

	var op: String = effect.get("op", "add")
	var amount = effect.get("amount", 0)
	var current_value = target.get(stat)
	var new_value = current_value

	match op:
		"add":
			new_value = current_value + amount
		"set":
			new_value = amount
		_:
			return

	if effect.has("min_value"): 
		new_value = max(new_value, effect["min_value"])

	target.set(stat, new_value) #將計算出的新值設置回目標對象的對應屬性

func destiny_random(exclude_keys: Array = []) -> Dictionary: 
	var available_keys = []
	for key in destiny_definitions.keys():#遍歷所有命運定義的 key，檢查是否符合條件加入可選列表
		# 排除已經被選入本次商店的 Key
		if key in exclude_keys:
			continue
			
		# 檢查是否有次數限制
		if destiny_counts.has(key):
			var max_count = _get_max_count(key)
			if destiny_counts[key] < max_count:
				available_keys.append(key)
		else:
			available_keys.append(key)
			
	if available_keys.is_empty():
		return {}
			
	var random_key = available_keys.pick_random()
	var definition: Dictionary = destiny_definitions[random_key] #根據隨機選中的 key 獲取對應的命運定義，如果沒有找到則返回空字典
	var level = destiny_counts.get(random_key, 0) + 1
	var title: String = definition.get("title", random_key) #獲取命運卡的標題，如果定義中沒有提供則使用 key 作為標題
	if definition.get("show_level_in_title", true): #如果定義中指定要在標題中顯示等級，則將等級以羅馬數字的形式添加到標題後面
		title += " " + get_roman_numeral(level)

	var result = {
		"key": random_key,
		"title": title,
		"icon": definition.get("icon", ""),
		"description": _build_description(definition, level)
	}

	return result


# 根據命運卡的標題應用對應的效果
func destiny_apply(destiny: Dictionary) -> void:
	var key = destiny.get("key", "") 
	if not destiny_definitions.has(key):
		return

	print("Applying destiny: " + destiny.get("title", key) + " (Key: " + key + ")")
	
	# 如果該 key 有計數器，則增加計數
	if destiny_counts.has(key):
		destiny_counts[key] += 1
		print(destiny.get("title", key) + " 已選擇 " + str(destiny_counts[key]) + " 次")

	var definition: Dictionary = destiny_definitions[key]
	var effects: Array = definition.get("effects", [])
	for effect in effects:
		_apply_effect(effect)

