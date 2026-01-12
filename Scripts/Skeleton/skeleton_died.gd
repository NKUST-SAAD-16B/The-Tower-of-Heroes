extends State
class_name SkeletonDied

func Enter():
	print("進入死亡狀態")
	actor.velocity.x = 0
	animated_sprite.animation_finished.connect(Exit)
	#停止偵測攻擊
	actor.hurtbox_component.set_deferred("monitoring", false)
	actor.hurtbox_component.set_deferred("monitorable", false)
	animated_sprite.play("died")

func Exit():
	actor.queue_free()

func Update(delta: float) -> void :
	pass

func Physics_process(delta: float) -> void :
	pass
