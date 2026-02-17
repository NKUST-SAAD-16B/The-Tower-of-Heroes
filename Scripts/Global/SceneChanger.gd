extends CanvasLayer

@onready var black = $Black

func change_scene(target_path: String):
	#播放淡出動畫 (變黑)，持續2秒
	var tween_out = create_tween()
	tween_out.tween_property(black, "modulate:a", 1.0, 2)
	await tween_out.finished
	
	#真正的切換場景
	get_tree().change_scene_to_file(target_path)
	
	#等待新場景節點進入樹
	await get_tree().process_frame
	
	#播放淡入動畫 (變透明)，持續2秒
	var tween_in = create_tween()
	tween_in.tween_property(black, "modulate:a", 0.0, 2)
	await tween_in.finished

# 只執行黑屏動作，不換場景
func fade_out():
	black.show()
	var tween := create_tween()
	tween.tween_property(black, "modulate:a", 1.0, 2)
	await tween.finished

# 從黑屏變回透明
func fade_in():
	var tween := create_tween()
	tween.tween_property(black, "modulate:a", 0.0, 2)
	await tween.finished
	black.hide()