extends State
class_name EnemyDied

func Enter():
	print("%s：死亡" % [actor.name])
	actor.velocity.x = 0
	if not animated_sprite.animation_finished.is_connected(Exit):
		animated_sprite.animation_finished.connect(Exit)
	#停止偵測攻擊
	actor.hurtbox_component.set_deferred("monitoring", false)
	actor.hurtbox_component.set_deferred("monitorable", false)
	animated_sprite.play("died")
	
	pass

func Exit():
	actor.queue_free()
	GameManager.current_enemy_quantity -= 1
	pass

func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	pass