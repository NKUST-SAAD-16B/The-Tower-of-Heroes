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

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("Pause"):
        PauseGame()
    pass

#生成玩家角色
func spawn_player(player_position: Vector2) -> void:
    #實例化玩家角色並添加到當前房間
    var player_instance = GameManager.player_scene.instantiate()
    get_node("CurrentRoom").add_child(player_instance)
    player_instance.position = player_position

#暫停遊戲
func PauseGame():
    print("遊戲暫停")
    get_tree().paused = true
    get_node("CanvasLayer/PauseMenu").show()