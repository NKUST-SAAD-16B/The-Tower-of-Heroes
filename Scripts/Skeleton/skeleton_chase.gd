extends State
class_name SkeletonChase
var chase_time = 3.0
var timer = 0.0
func Enter():
	print("骷髏：追逐玩家")
	animated_sprite.play("walk")
	timer = 0.0
	pass

func Exit():
	animated_sprite.stop()
	timer = 0.0
	pass

func Physics_process(delta: float) -> void :
	#目標存在就根據目標的X軸設定direction
	if actor.target != null:
		actor.direction = 1 if actor.target.global_position.x > actor.global_position.x else -1
	
	#目標存在且在攻擊範圍內就切換到攻擊狀態
	if actor.target != null and actor.global_position.distance_to(actor.target.global_position) <= 25:
		Transitioned.emit(self,"Attack")
		return
	
	#處理轉向
	if actor.direction == 1:
		actor.scale.y = 1
		actor.rotation = 0
	else:
		actor.scale.y = -1
		actor.rotation = PI
	
	#print(actor.direction)
	
	#如果目標離開偵測區域，開始計時
	if actor.target == null:
		timer += delta
		#ㄊprint(timer)
	
	#時間到就會回到idle狀態
	if timer >= chase_time:
		Transitioned.emit(self,"idle")
		return
	
	#如果偵測到懸空或牆壁就切換閒置動畫
	if not actor.floor_check.is_colliding() or actor.wall_check.is_colliding():
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		actor.velocity.x = 0
	else:
		if animated_sprite.animation == "idle":
			animated_sprite.stop()
			animated_sprite.play("walk")
		#追擊狀態速度
		actor.velocity.x = actor.WALK_SPEED * actor.direction
	
	pass

		
