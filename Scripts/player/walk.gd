extends State
class_name WalkState
#進入狀態時執行
func  Enter():
	print("玩家狀態：行走")
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
	
	# 偵測是否按住 Shift
	if Input.is_action_pressed("shift"):
		# 切換到 Run 狀態
		Transitioned.emit(self, "run")
		# 重要：return 代表這禎接下來的程式碼不用跑了，交給 Run 狀態去處理
		return
	
	#處理玩家方向及移動輸入
	var direction = Input.get_axis("left","right")
	
	if direction >= 1:
		actor.scale.y = 1
		actor.rotation = 0
		actor.velocity.x = actor.WALK_SPEED * direction
	elif direction == 0:
		Transitioned.emit(self,"idle")
	else:
		#向左走翻轉角色的y軸(顛倒)，並旋轉180度達成翻轉的效果
		actor.scale.y = -1
		actor.rotation = PI
		actor.velocity.x = actor.WALK_SPEED * direction
	

	pass
