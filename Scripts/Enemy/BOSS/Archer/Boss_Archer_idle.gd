extends EnemyIdle
class_name BossArcherIdle

# 覆寫父類別的 Physics_process
func Physics_process(delta: float) -> void :
	# 沿用減速與計時邏輯
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.walk_speed)
	timer += delta
	
	if timer >= idle_time :
		# 轉向邏輯
		actor.direction = [-1, 1].pick_random()
		if actor.direction == 1:
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.scale.y = -1
			actor.rotation = PI
			
		# 【關鍵修改】把原本的 "walk" 改成你的 Boss 擁有的狀態
		# 假設發呆完開始隨機移動，就填 "run"；如果想直接攻擊就填 "shoot"
		Transitioned.emit(self, "run")
