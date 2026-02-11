extends Node


#玩家場景
var player_scene = preload("res://Scenes/Character/player.tscn")

#開始新遊戲
func start_new_game():
	#使用call_deferred來確保場景切換在當前幀結束後執行，避免可能的問題
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/World.tscn")
	#初始化玩家數據
	PlayerData.player_data_init()
