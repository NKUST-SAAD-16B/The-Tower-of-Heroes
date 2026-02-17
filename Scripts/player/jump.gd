extends State
class_name JumpState
#進入狀態時執行
func  Enter():
	print("玩家狀態：跳躍")
	animated_sprite.play("jump")
	actor.velocity.y = -500
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	var direction = Input.get_axis("left","right")
	if not actor.is_on_floor():
		
		if direction >= 1:
			actor.scale.y = actor.player_scale
			actor.rotation = 0
			actor.velocity.x = actor.run_speed * direction
		elif direction == 0:
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.run_speed)
		else:
			actor.scale.y = -1 * actor.player_scale
			actor.rotation = PI
			actor.velocity.x = actor.run_speed * direction
	else:
		Transitioned.emit(self,"idle")
		#if direction != 0:
			#Transitioned.emit(self,"walk")
		#else:
			#Transitioned.emit(self,"idle")
	
	pass
