extends Node

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
}

func destiny_random() -> Dictionary:
    var keys = destiny_data.keys()
    var random_key = keys.pick_random()
    return destiny_data[random_key]

func destiny_apply(destiny: Dictionary) -> void:
    match destiny["title"]:
        "黑暗詛咒":
            # 增加敵人傷害20
            pass
        "惡魔的詠唱":
            # 增加敵人生命20
            pass
        "戰神的祝福":
            # 增加玩家傷害20
            pass
        "女神的庇護":
            # 增加玩家生命20
            pass
        "光明的庇護":
            # 減少敵人傷害20
            pass
        "光明的枷鎖":
            # 減少敵人生命20
            pass