extends State
class_name HurtState

func Enter():
	print("玩家狀態：受傷")
	animated_sprite.play("hurt")
	#進入受傷狀態時給腳色擊退速度
	actor.velocity = actor.knockback_vector
	#當hurt動畫播放完成會呼叫_on_animation_finished這個function
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)
	pass

func Exit():
	# 離開狀態時，斷開訊號，以免干擾其他狀態
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
	animated_sprite.stop()
	pass

func Physics_process(delta: float) -> void :
	if actor.velocity != Vector2.ZERO:
		var decay_rate = actor.knockback_resist
		actor.velocity *= pow(1 - decay_rate, delta)  # 指數衰減(讓擊退看起來更自然)
		if actor.velocity.length() < 1:  # 防止浮點誤差
			actor.velocity = Vector2.ZERO

func _on_animation_finished():
	Transitioned.emit(self,"idle")
	pass
