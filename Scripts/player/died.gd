extends State
class_name DiedState



#進入狀態時執行
func  Enter():
	print("玩家狀態：死亡")
	actor.velocity.x = 0
	animated_sprite.play("died")
	if not animated_sprite.animation_finished.is_connected(_on_lose):
		animated_sprite.animation_finished.connect(_on_lose)

	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lose() -> void:
	
	#顯示"You Died"畫面
	var you_died_screen = get_tree().current_scene.get_node("CanvasLayer/YouDied")
	you_died_screen.show_you_died()
	you_died_screen.game_over_flag = true # 設置遊戲結束標誌
	#遊戲暫停
	get_tree().paused = true
	pass
