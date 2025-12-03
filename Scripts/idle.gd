extends State

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
	player.velocity.x = move_toward(player.velocity.x, 0, player.WALK_SPEED)
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self,"jump")
	
	var direction = Input.get_axis("ui_left","ui_right")
	if direction != 0:
		#如果左右鍵被按下，就切換到走路狀態
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			Transitioned.emit(self,"walk")
	
	#切換攻擊狀態
	if Input.is_action_just_pressed("mouse_left"):
		Transitioned.emit(self,"attack")
	
	pass
