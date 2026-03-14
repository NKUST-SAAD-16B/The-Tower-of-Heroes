extends EnemyWalk
class_name BossArcherRun


var run_duration: float = 3.0 # 設定跑 3 秒

func Enter():
	animated_sprite.play("run")
	timer = 0.0
	
	# 決定方向：遠離玩家
	if actor.target is Player:
		# 比較 X 座標，決定反方向
		if actor.target.global_position.x > actor.global_position.x:
			actor.direction = -1 # 玩家在右，往左跑
			actor.scale.y = -1
			actor.rotation = PI
		else:
			actor.direction = 1  # 玩家在左，往右跑
			actor.scale.y = 1
			actor.rotation = 0
	else:
		actor.direction = [-1, 1].pick_random()

func Physics_process(delta: float) -> void:
	# 執行移動 (速度可以依需求乘上倍率，例如 1.5 倍速拉開距離)
	actor.velocity.x = actor.direction * actor.walk_speed * 2 
	
	# 計時器累加
	timer += delta
	if timer >= run_duration:
		# 3秒時間到，把速度歸零，準備切換狀態
		actor.velocity.x = 0
		
		# 【最容易出錯的地方】檢查你要切換的狀態名稱是否跟節點名稱完全一樣
		# 這裡填 "shoot"，讓它跑完拉開距離後直接轉身射擊
		Transitioned.emit(self, "shoot")
