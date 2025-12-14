extends State
class_name SkeletonHurt
func Enter():
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
	pass

func Physics_process(delta: float) -> void :
	#擊退減速
	if actor.velocity != Vector2.ZERO:
		var decay_rate = actor.knockback_resist * delta
		actor.velocity.move_toward(Vector2.ZERO,decay_rate)
	pass

func _on_animation_finished():
	Transitioned.emit(self,"idle")
	pass
