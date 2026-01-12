extends State
class_name JumpState
#進入狀態時執行
func  Enter():
	print("玩家狀態：跳躍")
	animated_sprite.play("jump")
	actor.velocity.y = -300

#離開狀態時執行
func Exit():
	animated_sprite.stop()


func Update(delta: float) -> void :
	pass

func Physics_process(delta: float) -> void :
	var direction = Input.get_axis("left","right")
	if not actor.is_on_floor():
		
		if direction >= 1:
			actor.scale.y = 1
			actor.rotation = 0
			actor.velocity.x = actor.RUN_SPEED * direction
		elif direction == 0:
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.RUN_SPEED)
		else:
			actor.scale.y = -1
			actor.rotation = PI
			actor.velocity.x = actor.RUN_SPEED * direction
	else:
		Transitioned.emit(self,"idle")
		#if direction != 0:
			#Transitioned.emit(self,"walk")
		#else:
			#Transitioned.emit(self,"idle")
