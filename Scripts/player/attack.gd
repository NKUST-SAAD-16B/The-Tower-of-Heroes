extends State
class_name AttackState
var is_combo = false
var combo_count = 1



func  Enter():
	animated_sprite.play("attack_1")
	actor.hitbox_1.disabled = false
	#當attack動畫播放完成會呼叫_on_animation_finished這個function
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)
	combo_count = 1      # 重置計數
	is_combo = false  # 重置預約
	pass


func Exit():
	animated_sprite.stop()
	_hitbox_disabled()
	# 離開狀態時，斷開訊號，以免干擾其他狀態
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
	pass

func Physics_process(delta: float) -> void :
	
	#攻擊時按下左鍵會計入連擊
	if Input.is_action_just_pressed("attack"):
		is_combo = true
	pass


func _on_animation_finished():
	_hitbox_disabled()
	print("連擊" + str(combo_count))
	if is_combo and combo_count < 3 :
		#animated_sprite.play("attack_2")
		combo_count += 1
		is_combo = false
		animated_sprite.play("attack_" + str(combo_count))
		#根據攻擊開啟對應的hitbox碰撞框
		match combo_count:
			1:
				actor.hitbox_1.set_deferred("disabled", false)
			2:
				actor.hitbox_2.set_deferred("disabled", false)
			3:
				actor.hitbox_3.set_deferred("disabled", false)
	else:
		Transitioned.emit(self,"idle")
	
	pass

func _hitbox_disabled():
	actor.hitbox_1.set_deferred("disabled", true)
	actor.hitbox_2.set_deferred("disabled", true)
	actor.hitbox_3.set_deferred("disabled", true)
	#actor.hitbox_1.disabled = true
	#actor.hitbox_2.disabled = true
	#actor.hitbox_3.disabled = true
