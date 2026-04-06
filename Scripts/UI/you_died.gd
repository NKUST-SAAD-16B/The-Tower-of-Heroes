extends Control

@onready var prssed_accept = false # 用於追蹤是否已按下跳躍鍵
@onready var game_over_flag = false # 用於追蹤遊戲是否已結束
@onready var can_accept_input = false # 用於控制何時可以接受玩家輸入
func _ready() -> void:
	#初始隱藏
	self.hide()



func show_you_died() -> void:
	#慢慢顯示"You Died"畫面
	self.show()
	#先刪除存檔，確保玩家無法繼續之前的遊戲
	GameManager.delete_save()
	# 建立 Tween 並設定為並行模式
	var tween = create_tween().set_parallel(true)
	
	# 背景淡入
	tween.tween_property($ColorRect, "modulate:a", 0.8, 1.0).from(0.0)
	
	# 文字淡入（與背景同時）
	tween.tween_property($Label, "modulate:a", 1.0, 1.0).from(0.0)
	
	# 文字放大（與背景、文字淡入同時）
	tween.tween_property($Label, "scale", Vector2(1.0, 1.0), 3.0).as_relative()

	await tween.finished

	#開始閃爍提示文字
	start_flashing_label()

func start_flashing_label():
	var label = $Label2
	label.modulate.a = 0.0  # 初始為透明
	label.show()

	# 建立一個無限循環的 Tween
	var tween = create_tween().set_loops()
	
	# 文字閃爍：從透明到不透明再回到透明
	tween.tween_property(label, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE)
	
	# 文字閃爍：從不透明回到透明
	tween.tween_property(label, "modulate:a", 0.2, 1.2).set_trans(Tween.TRANS_SINE)

	can_accept_input = true # 開始接受玩家輸入

func _process(delta: float) -> void:
	if can_accept_input and Input.is_action_just_pressed("ui_accept"):
		prssed_accept = true
		
		SceneChanger.change_scene("res://Scenes/UI/MainMenu.tscn")
		get_tree().paused = false # 確保遊戲恢復運行