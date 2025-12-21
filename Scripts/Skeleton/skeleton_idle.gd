extends State
class_name SkeletonIdle

@onready var idle_time = 3.0
var timer : float
#進入狀態時執行
func  Enter():
	animated_sprite.play("idle")
	timer = 0.0
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	timer = 0.0
	pass


func Update(delta: float) -> void :
	pass

func Physics_process(delta: float) -> void :
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.WALK_SPEED)
	timer += delta
	if timer >= idle_time :
		Transitioned.emit(self,"walk")
	

	pass
	
