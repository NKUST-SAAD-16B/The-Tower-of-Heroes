extends State

var walk_time = 5.0
var direction = 1
func Enter():
	animated_sprite.play("walk")
func Exit():
	animated_sprite.stop()
	
	pass

func Physics_process(delta: float) -> void :
	if not actor.floor_check.is_colliding() or  actor.wall_check.is_colliding():
		print("turn")
		_turn_around()
		
	actor.velocity.x = 0
	actor.velocity.x = actor.WALK_SPEED * direction
	pass
	
func _turn_around():
	if animated_sprite.flip_h == false:
		direction = -1
		animated_sprite.flip_h = true

		
