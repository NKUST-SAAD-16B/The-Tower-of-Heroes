extends State
class_name DefenseState


#進入狀態時執行
func  Enter():
	print("玩家狀態：防禦")
	animated_sprite.play("defense")
	if not actor.hurtbox_component.defense_hit.is_connected(defense_detection):
		actor.hurtbox_component.defense_hit.connect(defense_detection)
	
#離開狀態時執行
func Exit():
	animated_sprite.stop()
	if actor.hurtbox_component.defense_hit.is_connected(defense_detection):
		actor.hurtbox_component.defense_hit.disconnect(defense_detection)
	pass

func Physics_process(delta: float) -> void :
	#當玩家放開防禦按鍵時，轉換回idle狀態
	if Input.is_action_just_released("defense"):
		Transitioned.emit(self,"idle")
	#當動畫播放到特定幀時停止動畫，保持防禦姿勢
	if animated_sprite.is_playing() and animated_sprite.frame == 1:
		animated_sprite.pause()
	
	if actor.velocity != Vector2.ZERO:
		var decay_rate = actor.knockback_resist
		actor.velocity *= pow(1 - decay_rate, delta)  # 指數衰減(讓擊退看起來更自然)
		if actor.velocity.length() < 1:  # 防止浮點誤差
			actor.velocity = Vector2.ZERO

#當玩家被攻擊時，根據攻擊者位置來決定是否成功格擋
func defense_detection(attacker_position:Vector2 , defense_success:Dictionary) -> void:
	#判斷玩家面向方向
	var player_direction = Vector2.RIGHT if actor.scale.y > 0 else Vector2.LEFT
	#計算攻擊者相對於玩家的方向
	var relative_position = (attacker_position - actor.global_position).normalized()
	#計算內積來判斷攻擊者是否在玩家面向的方向
	var result = player_direction.dot(relative_position)
	#如果攻擊者在玩家面向的方向，則成功格擋
	if result > 0:
		print("成功格擋！")
		#成功格擋後可以繼續播放防禦動畫後半段
		animated_sprite.frame = 2
		animated_sprite.play()
		#給予玩家一個小的擊退效果，讓玩家有被攻擊到的感覺，但不會真正受到傷害
		actor.velocity = (Vector2(50,0) * player_direction) * -1
		#修改defense_success的值，讓hurtbox知道玩家成功格擋了攻擊
		defense_success["success"] = true
	else:
		print("格擋失敗！")

	pass # Replace with function body.
