extends State

#進入狀態時執行
func  Enter():
	animated_sprite.play("walk")
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self,"jump")
	
	# 偵測是否按住 Shift (對應我們剛剛設定的 "run")
	if Input.is_action_pressed("shift"):
		# 切換到 Run 狀態
		Transitioned.emit(self, "run")
		# 重要：return 代表這禎接下來的程式碼不用跑了，交給 Run 狀態去處理
		return
	
	#處理玩家方向及移動輸入
	var direction = Input.get_axis("ui_left","ui_right")
		
	if direction >= 1:
		animated_sprite.flip_h = false
		player.velocity.x = player.WALK_SPEED * direction
	elif direction == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.WALK_SPEED)
		Transitioned.emit(self,"idle")
	else:
		animated_sprite.flip_h = true
		player.velocity.x = player.WALK_SPEED * direction

	pass
