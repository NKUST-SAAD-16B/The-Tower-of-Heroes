extends Node2D

#房間路徑
var room_paths = [
	"res://Scenes/Map/room_1.tscn",
	"res://Scenes/Map/room_2.tscn",
	"res://Scenes/Map/room_3.tscn",
	"res://Scenes/Map/room_4.tscn"
]

func _ready() -> void:
    #隨機選擇一個房間場景並實例化
    var current_scene = randi() % room_paths.size()
    var room_scene = load(room_paths[current_scene])
    var room_instance = room_scene.instantiate()
    get_node("CurrentRoom").add_child(room_instance)
    spawn_player(room_instance.get_node("PlayerSpawn").global_position)
    pass

func spawn_player(player_position: Vector2) -> void:
    var player_instance = GameManager.player_scene.instantiate()
    get_node("CurrentRoom").add_child(player_instance)
    player_instance.position = player_position