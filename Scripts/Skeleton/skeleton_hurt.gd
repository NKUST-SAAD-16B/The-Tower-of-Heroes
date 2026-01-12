extends State
class_name SkeletonHurt

func Enter():
	print("玩家狀態：受傷")
	animated_sprite.play("hurt")
	#進入受傷狀態時給腳色擊退速度
	actor.velocity = actor.knockback_vector
	#當hurt動畫播放完成會呼叫_on_animation_finished這個function
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

func Exit():
	# 離開狀態時，斷開訊號，以免干擾其他狀態
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
	animated_sprite.stop()

func Physics_process(delta: float) -> void :
	if actor.velocity != Vector2.ZERO:
		var decay_rate = actor.knockback_resist
		actor.velocity *= pow(1 - decay_rate, delta)  # 指數衰減(讓擊退看起來更自然)
		if actor.velocity.length() < 1:  # 防止浮點誤差
			actor.velocity = Vector2.ZERO

func _on_animation_finished():
	#偵測範圍內的敵人，如果有就chase狀態、沒有就回idle狀態
	if actor.player_checker.has_overlapping_bodies():
		for body in actor.player_checker.get_overlapping_bodies():
			if body is Player:
				actor.target = body
				Transitioned.emit(self,"chase")
	else:
		Transitioned.emit(self,"idle")
