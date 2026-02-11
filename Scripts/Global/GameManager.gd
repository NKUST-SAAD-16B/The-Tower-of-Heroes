extends Node





#玩家場景
var player_scene = preload("res://Scenes/Character/player.tscn")

#開始新遊戲
func start_new_game():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
