extends Node

#房間路徑
var room_paths = [
	"res://Scenes/Map/room_1.tscn",
	"res://Scenes/Map/room_2.tscn",
	"res://Scenes/Map/room_3.tscn",
	"res://Scenes/Map/room_4.tscn"
]

#玩家場景

var player_scene = preload("res://Scenes/Character/player.tscn")

func statr_new_game():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
