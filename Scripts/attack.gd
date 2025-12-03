extends State

var is_combo = false
var combo_count = 1

func  Enter():
	animated_sprite.play("attack_1")
	#當attack動畫播放完成會呼叫_on_animation_finished這個function
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)
	combo_count = 1      # 重置計數
	is_combo = false  # 重置預約
	pass


func Exit():
	
	animated_sprite.stop()
	
	# 離開狀態時，斷開訊號，以免干擾其他狀態
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
	pass

func Physics_process(delta: float) -> void :
	
	#攻擊時按下左鍵會計入連擊
	if Input.is_action_just_pressed("mouse_left"):
		is_combo = true
	pass


func _on_animation_finished():
	print("連擊" + str(combo_count))
	if is_combo and combo_count < 3 :
		animated_sprite.play("attack_2")
		combo_count += 1
		is_combo = false
		animated_sprite.play("attack_" + str(combo_count))
		
	else:
		Transitioned.emit(self,"idle")
		
	pass
