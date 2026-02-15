extends Node2D


#房間路徑
var room_paths = [
	"res://Scenes/Map/room_1.tscn",
	"res://Scenes/Map/room_2.tscn",
	"res://Scenes/Map/room_3.tscn",
	"res://Scenes/Map/room_4.tscn"
]
#玩家UI場景
@onready var PlayerUI: PlayerGameUI = $Player_UI

#敵人場景，用於隨機生成敵人，需在編輯器中設置
@export var enemy_scene : Array[PackedScene] = []

@onready var enemy_spawn_quantity = 10

func _ready() -> void:
	#房間過渡，生成第一個房間
	room_transition()
	#啟動敵人生成計時器，每2秒生成一個敵人
	get_node("EnemySpawnTimer").start()
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		PauseGame()
	pass

func room_transition():
	#隨機選擇一個房間場景並實例化
	var current_scene = randi() % room_paths.size()
	var room_scene = load(room_paths[current_scene])
	var room_instance = room_scene.instantiate()
	get_node("CurrentRoom").add_child(room_instance)
	#在房間中生成玩家角色，位置為房間中名為"PlayerSpawn"的節點位置
	spawn_player(room_instance.get_node("PlayerSpawn").global_position)
	enemy_spawn_quantity *= (1 + DestinyManager.enemy_quantity_multiplier)

#生成玩家角色
func spawn_player(player_position: Vector2) -> void:
	#實例化玩家角色並添加到當前房間
	var player_instance = GameManager.player_scene.instantiate()
	get_node("CurrentRoom").add_child(player_instance)
	player_instance.position = player_position
	#設置玩家UI的HealthComponent引用
	PlayerUI.health_component = player_instance.health_component
	PlayerUI.setup_ui()
	pass


#暫停遊戲
func PauseGame():
	print("遊戲暫停")
	get_tree().paused = true
	get_node("CanvasLayer/PauseMenu").show()

#隨機生成敵人
func EnemySpawn():
	#從所有敵人生成點中隨機選擇一個，並在該位置生成一個敵人
	var all_points = get_tree().get_nodes_in_group("EnemySpawnPoints")
	#從enemy_scene中隨機選擇一個敵人場景並實例化
	var spawn_point = all_points.pick_random()
	var enemy = enemy_scene.pick_random().instantiate()
	#將生成的敵人添加到當前房間
	get_node("CurrentRoom").add_child(enemy)
	#將生成的敵人位置設置為選擇的生成點位置
	enemy.position = spawn_point.global_position


#敵人生成計時器觸發時生成敵人
func _on_enemy_spawn_timer_timeout() -> void:
	EnemySpawn()
	enemy_spawn_quantity -= 1
	print("生成敵人，剩餘生成數量: " + str(enemy_spawn_quantity))
	#當敵人生成數量小於等於0時停止生成敵人
	if enemy_spawn_quantity <= 0:
		get_node("EnemySpawnTimer").stop()
		print("敵人全部生成完畢")
