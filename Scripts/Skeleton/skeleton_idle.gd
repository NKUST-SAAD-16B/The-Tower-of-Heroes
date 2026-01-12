extends State
class_name SkeletonIdle

@onready var idle_time = 3.0
var timer : float
#進入狀態時執行
func  Enter():
	print("idle")
	animated_sprite.play("idle")
	timer = 0.0

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	timer = 0.0


func Update(delta: float) -> void :
	pass
	
func Physics_process(delta: float) -> void :
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.WALK_SPEED)
	timer += delta
	
	
	if timer >= idle_time :
		actor.direction = [-1, 1].pick_random()
		if actor.direction == 1:
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.scale.y = -1
			actor.rotation = PI
		Transitioned.emit(self,"walk")
	
