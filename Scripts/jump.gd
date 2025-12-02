extends State

#進入狀態時執行
func  Enter():
	animated_sprite.play("jump")
	player.velocity.y = -300
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	var direction = Input.get_axis("ui_left","ui_right")
	if not player.is_on_floor():
		
		if direction >= 1:
			animated_sprite.flip_h = false
			player.velocity.x = player.RUN_SPEED * direction
		elif direction == 0:
			player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_SPEED)
		else:
			animated_sprite.flip_h =true
			player.velocity.x = player.RUN_SPEED * direction
	else:
		
		if direction != 0:
			Transitioned.emit(self,"run")
		else:
			Transitioned.emit(self,"idle")
	
	pass
