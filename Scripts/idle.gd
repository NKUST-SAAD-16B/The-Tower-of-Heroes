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
	if Input.is_action_just_pressed("space"):
		Transitioned.emit(self,"jump")
	#如果左右鍵被按下，就切換到走路狀態
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		Transitioned.emit(self,"walk")
	
	

	pass
