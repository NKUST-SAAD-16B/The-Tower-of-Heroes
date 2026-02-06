extends State
class_name RunState
#進入狀態時執行
func  Enter():
	print("玩家狀態：奔跑")
	animated_sprite.play("run")
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass

func Physics_process(delta: float) -> void :
	
	
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self,"jump")
	
	if Input.is_action_just_released("shift"):
		Transitioned.emit(self, "walk")
		return
		
	#處理玩家方向及移動輸入
	var direction = Input.get_axis("left","right")
	if direction >= 1:
		actor.scale.y = actor.player_scale
		actor.rotation = 0
		actor.velocity.x = actor.run_speed * direction
	elif direction == 0:
		Transitioned.emit(self,"idle")
	else:
		actor.scale.y = -1 * actor.player_scale
		actor.rotation = PI
		actor.velocity.x = actor.run_speed * direction

	pass
