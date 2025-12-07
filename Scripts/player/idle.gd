extends State
class_name IdleState
#進入狀態時執行
func  Enter():
	animated_sprite.play("idle")
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


func Update(delta: float) -> void :

	pass

func Physics_process(delta: float) -> void :
	
	
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.WALK_SPEED)
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self,"jump")
	
	var direction = Input.get_axis("left","right")
	if direction != 0:
		#如果左右鍵被按下，就切換到走路狀態
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			Transitioned.emit(self,"walk")
	
	#切換攻擊狀態
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit(self,"attack")
	
	pass
