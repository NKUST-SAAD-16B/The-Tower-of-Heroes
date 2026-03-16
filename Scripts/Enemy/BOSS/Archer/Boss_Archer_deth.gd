extends EnemyDied
class_name BossArcherDied

func Enter():
	# 速度歸零，避免滑行
	actor.velocity = Vector2.ZERO
	
	# 2. 關閉 Boss 的主要實體碰撞 (避免死後擋路)
	# actor.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	#  關閉 Hurtbox，避免死後還能被玩家攻擊吸血或觸發特效
	if actor.has_node("HurtboxComponent/CollisionShape2D"):
		actor.get_node("HurtboxComponent/CollisionShape2D").set_deferred("disabled", true)
	
	# 播放死亡動畫
	animated_sprite.play("death") # 這裡填入你的死亡動畫名稱
	
	# 連接動畫結束訊號，準備刪除節點
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	if animated_sprite.animation == "death": # 確保是死亡動畫播完
		actor.queue_free() # 徹底從場景中刪除 Boss
