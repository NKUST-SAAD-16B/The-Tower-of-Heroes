extends Node


#玩家場景
var player_scene = preload("res://Scenes/Character/player.tscn")

signal enemy_defeated

#當前樓層數，初始值為1，每次房間過渡時增加1	
var current_floor : int = 0

#敵人生成數量，初始值為10，根據DestinyManager的enemy_quantity_multiplier進行修改
var enemy_spawn_quantity : int = 10:
	#當enemy_spawn_quantity被修改時，同步更新current_enemy_quantity的值，確保它們保持一致
	set(value):
		current_enemy_quantity = value
		enemy_spawn_quantity = value

#當前敵人數量
var current_enemy_quantity : int = enemy_spawn_quantity:
	set(value):
		current_enemy_quantity = value
		print("當前敵人數量: " + str(current_enemy_quantity))
		#當當前敵人數量小於等於0時觸發enemy_defeated信號，通知world.gd進行商店過渡
		if current_enemy_quantity <= 0:
			enemy_defeated.emit()

#開始新遊戲
func start_new_game():
	#使用call_deferred來確保場景切換在當前幀結束後執行，避免可能的問題
	get_tree().call_deferred("change_scene_to_file", )
	#get_tree().change_scene_to_file("res://Scenes/test.tscn")
	#初始化玩家數據
	
