extends Node

# 命運管理器，負責生成和應用命運卡的效果

# 敵人傷害和生命的修改器，初始值為0，根據選擇的命運卡進行增減
var enemy_damage_modifier = 0
var enemy_health_modifier = 0
var enemy_walk_speed_modifier = 0
var enemy_quantity_multiplier = 0
var destiny_data = {
	"Enemy_damage_increase": {
		"title": "黑暗詛咒",
		"icon": "res://path_to_destiny_1_icon.png",
		"description": "敵人的傷害增加20",
	},
	"Enemy_health_increase": {
		"title": "惡魔的詠唱",
		"icon": "res://path_to_destiny_2_icon.png",
		"description": "敵人的生命增加20"
	},
	"Player_damage_increase": {
		"title": "戰神的祝福",
		"icon": "res://path_to_destiny_3_icon.png",
		"description": "玩家的傷害增加20"
	},
	"Player_health_increase": {
		"title": "女神的庇護",
		"icon": "res://path_to_destiny_4_icon.png",
		"description": "玩家的生命增加20"
	},
	"Enemy_damage_reduction": {
		"title": "光明的庇護",
		"icon": "res://path_to_destiny_5_icon.png",
		"description": "敵人的傷害減少20"
	},
	"Enemy_health_reduction": {
		"title": "光明的枷鎖",
		"icon": "res://path_to_destiny_6_icon.png",
		"description": "敵人的生命減少20"
	},
	"Enemy_speed_increase": {
		"title": "暗影的加速",
		"icon": "res://path_to_destiny_7_icon.png",
		"description": "敵人的移動速度增加20"
	},
	"Enemy_quantity_increase": {
		"title": "怪物奉上",
		"icon": "res://path_to_destiny_8_icon.png",
		"description": "敵人數量增加10%"
	},

}

func destiny_random() -> Dictionary:
	var keys = destiny_data.keys()
	var random_key = keys.pick_random()
	return destiny_data[random_key]

func destiny_apply(destiny: Dictionary) -> void:
	print("Applying destiny: " + destiny["title"])
	match destiny["title"]:
		"黑暗詛咒":
			# 增加敵人傷害20
			enemy_damage_modifier += 20
		"惡魔的詠唱":
			# 增加敵人生命20
			enemy_health_modifier += 20
		"戰神的祝福":
			# 增加玩家傷害20
			PlayerData.player_base_damage += 20
		"女神的庇護":
			# 增加玩家生命20
			PlayerData.player_max_health += 20
		"光明的庇護":
			# 減少敵人傷害20
			enemy_damage_modifier -= 20
		"光明的枷鎖":
			# 減少敵人生命20
			enemy_health_modifier -= 20
		"暗影的加速":
			# 增加敵人移動速度20
			enemy_walk_speed_modifier += 20
		"怪物奉上":
			# 增加敵人數量10%
			enemy_quantity_multiplier += 0.1
