extends State
class_name EnemyWalk

var walk_time = randf_range(2.0, 5.0) #行走時間，隨機行走2到5秒

var timer = 0.0
func Enter():
	print("%s狀態：行走" % [actor.name])
	animated_sprite.play("walk")
func Exit():
	animated_sprite.stop()
	timer = 0.0
	pass

func Physics_process(delta: float) -> void :
	timer += delta
	if timer >= walk_time:
		Transitioned.emit(self,"idle")
	#牆壁和地板偵測
	if not actor.floor_check.is_colliding() or  actor.wall_check.is_colliding():
		#print("turn")
		
		_turn_around()
	
	
	actor.velocity.x = actor.walk_speed * actor.direction
	pass
	
func _turn_around():
	actor.direction *= -1
	if actor.scale.y == -1:
		actor.scale.y = 1
		actor.rotation = 0
	else:
		actor.scale.y = -1
		actor.rotation = PI