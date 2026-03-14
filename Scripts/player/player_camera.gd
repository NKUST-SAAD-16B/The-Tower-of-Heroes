extends Camera2D

#玩家攝像機腳本，負責跟隨玩家角色並實現攻擊時的畫面震動效果
var screen_shake_intensity = 0


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	
	if screen_shake_intensity > 0:
		#根據震動強度生成隨機偏移
		var shake_offset = Vector2(randf_range(-screen_shake_intensity, screen_shake_intensity), randf_range(-screen_shake_intensity, screen_shake_intensity))
		#應用震動偏移
		self.offset = shake_offset

	screen_shake_intensity = move_toward(screen_shake_intensity, 0, 100 * delta) #逐漸減小震動強度，直到回到0

#hitbox發出hit_shake訊號時會呼叫apply_screen_shake這個function，並將震動強度作為參數傳入
func apply_screen_shake(intensity: float) -> void:
	screen_shake_intensity = intensity
