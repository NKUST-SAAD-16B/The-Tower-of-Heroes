extends State
class_name EnemyIdle


@onready var idle_time = randf_range(2.0, 4.0) #閒置時間，隨機閒置2到4秒
var timer : float
#進入狀態時執行
func  Enter():
	print("%s狀態：閒置" % [actor.name])
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
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.walk_speed)
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
	pass
	