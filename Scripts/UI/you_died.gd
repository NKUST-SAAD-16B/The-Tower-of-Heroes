extends Control

func _ready() -> void:
	#初始隱藏
	self.hide()
	show_you_died()

func show_you_died() -> void:
	#慢慢顯示"You Died"畫面
	self.show()
	# 建立 Tween 並設定為並行模式
	var tween = create_tween().set_parallel(true)
	
	# 背景淡入
	tween.tween_property($ColorRect, "modulate:a", 1.0, 1.0).from(0.0)
	
	# 文字淡入（與背景同時）
	tween.tween_property($Label, "modulate:a", 1.0, 1.0).from(0.0)
	
	# 文字放大（與背景、文字淡入同時）
	tween.tween_property($Label, "scale", Vector2(1.0, 1.0), 3.0).as_relative()
