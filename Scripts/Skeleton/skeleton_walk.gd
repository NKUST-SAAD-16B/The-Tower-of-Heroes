extends State

var walk_time = 5.0

var timer = 0.0
func Enter():
	print("walk")
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
	
	
	actor.velocity.x = actor.WALK_SPEED * actor.direction
	pass
	
func _turn_around():
	actor.direction *= -1
	if actor.scale.y == -1:
		actor.scale.y = 1
		actor.rotation = 0
	else:
		actor.scale.y = -1
		actor.rotation = PI

		
