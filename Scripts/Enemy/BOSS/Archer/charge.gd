extends State
class_name BossArcherCharge

var timer: float = 0.0
var charge_duration: float = 1.0 # 衝撞時間 (因為速度快，可以設短一點)

func Enter():
	# 假設你還沒有專屬的衝撞動畫，先沿用奔跑動畫
	animated_sprite.play("run")
	timer = 0.0
	
	# 決定方向：朝向玩家
	if actor.target is Player:
		if actor.target.global_position.x > actor.global_position.x:
			actor.direction = 1  # 玩家在右，往右衝
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.direction = -1 # 玩家在左，往左衝
			actor.scale.y = -1
			actor.rotation = PI
	else:
		actor.direction = [-1, 1].pick_random()

	# 【可選】如果你希望 Boss 撞到玩家會扣血，需要把身上負責近戰判定的 Hitbox 打開
	if actor.has_node("HitboxComponent/Attack"):
		actor.get_node("HitboxComponent/Attack").set_deferred("disabled", false)

func Physics_process(delta: float) -> void:
	# 執行移動：速度設為原本走速的 3 倍 (可自行調整數值)
	actor.velocity.x = actor.direction * actor.walk_speed * 3.0 
	
	timer += delta
	if timer >= charge_duration:
		# 衝撞結束，速度歸零
		actor.velocity.x = 0
		# 衝完後接著射擊
		Transitioned.emit(self, "shoot") 

func Exit():
	animated_sprite.stop()
	# 【可選】離開狀態時，記得把近戰 Hitbox 關閉
	# if actor.has_node("HitboxComponent/Attack"):
	# 	actor.get_node("HitboxComponent/Attack").set_deferred("disabled", true)
