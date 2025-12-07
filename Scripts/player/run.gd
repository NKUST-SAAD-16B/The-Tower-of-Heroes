extends State
class_name RunState
#進入狀態時執行
func  Enter():
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
		animated_sprite.flip_h = false
		actor.velocity.x = actor.RUN_SPEED * direction
	elif direction == 0:
		Transitioned.emit(self,"idle")
	else:
		animated_sprite.flip_h = true
		actor.velocity.x = actor.RUN_SPEED * direction

	pass
