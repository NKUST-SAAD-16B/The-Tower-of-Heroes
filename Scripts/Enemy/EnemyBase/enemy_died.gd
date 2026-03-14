extends State
class_name EnemyDied

func Enter():
	print("%s：進入死亡狀態，準備播放動畫: died" % [actor.name])
	actor.velocity.x = 0

	if animated_sprite:
		print("%s：找到 AnimatedSprite2D，當前動畫: %s" % [actor.name, animated_sprite.animation])
		if not animated_sprite.animation_finished.is_connected(Exit):
			animated_sprite.animation_finished.connect(Exit)
		animated_sprite.play("died")
	else:
		print("%s：錯誤！找不到 AnimatedSprite2D" % [actor.name])
		Exit() # 沒動畫就直接消失

	#停止偵測攻擊
	actor.hurtbox_component.set_deferred("monitoring", false)
	actor.hurtbox_component.set_deferred("monitorable", false)


func Exit():
	actor.queue_free()
	GameManager.current_enemy_quantity -= 1
	pass

func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	pass
