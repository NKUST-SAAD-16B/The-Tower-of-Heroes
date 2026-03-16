extends Enemy
class_name BossArcher

var hit_count: int = 0
@onready var phase_component: PhaseComponent = $PhaseComponent

func _ready() -> void:
	super._ready()
	
	# 連接 PhaseComponent 的二階段訊號
	if phase_component and not phase_component.phase_2_entered.is_connected(_on_phase_2_entered):
		phase_component.phase_2_entered.connect(_on_phase_2_entered)
		
# 覆寫父類別的 _hurt 函數 
func _hurt(knockback):
	# 【新增防呆】如果血量已經低於或等於 0，代表觸發了死亡，直接中斷受傷邏輯
	if health_component.current_health <= 0:
		return
	# 每次觸發受傷訊號，計數器 +1
	hit_count += 1
	print("%s 目前受擊次數: %d" % [name, hit_count])
	
	if hit_count >= 3:
		# 達到 3 次，重置計數器
		hit_count = 0
		# 保留父類別記錄擊退向量的邏輯 
		self.knockback_vector = knockback 
		
		print("%s：受擊達標，檢查二階段狀態: %s" % [name, phase_component.is_phase_2])
		
		# 【修改這裡】判斷是否進入二階段
		if phase_component.is_phase_2:
			# 二階段：切換到幻影衝刺狀態
			state_machine.current_state.Transitioned.emit(state_machine.current_state, "phantom_dash")
		else:
			# 一階段：強制狀態機切換到 "run" (反向逃跑)
			state_machine.current_state.Transitioned.emit(state_machine.current_state, "run")
	else:
		# 還沒達到 3 次，呼叫父類別 (Enemy) 原本的 _hurt 邏輯 
		super._hurt(knockback)

func _on_player_checker_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		# 檢查當前狀態，避免死亡時還切換
		if state_machine.current_state.name != "death": # 這裡也要確保是對應 death
			# Boss 發現玩家後，切換到 "shoot" 準備射擊
			state_machine.current_state.Transitioned.emit(state_machine.current_state, "shoot")
			
func _on_player_checker_body_exited(body: Node2D) -> void:
	if body is Player:
		# 1. 先將目標清空
		target = null 
		# 2. 建立一個 x 秒的計時器，並在此暫停這段程式碼的執行
		await get_tree().create_timer(2.0).timeout
		# 3. 三秒後進行防呆檢查：
		# - target == null：確保這 x 秒內玩家沒有跑回來 (如果跑回來，target 會在 body_entered 被重新賦值)
		# - state_machine.current_state.name != "death"：確保 Boss 這 x 秒內沒有被打死，避免死屍突然站起來發呆
		if target == null and state_machine.current_state.name != "death":
			print("%s：脫戰成功，返回 idle 狀態" % name)
			state_machine.current_state.Transitioned.emit(state_machine.current_state, "idle")

func _died():
	print("%s：死亡" % name)
	# 【修正】確保發送的狀態名稱是 "death"，與節點名稱一致
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "death")
	
# 執行進入二階段的處理
func _on_phase_2_entered() -> void:
	print("%s：接收到訊號，正式進入二階段！" % name)
	
	# 1. 數值強化：提高移動速度
	walk_speed *= 1.5
	
	# 2. 視覺回饋：閃爍白色或播放特效 (假設你有對應的邏輯)
	# 這裡先用簡單的調色閃爍示範
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.2)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	tween.set_loops(3)
	
	# 3. 可以在這裡加入全螢幕震動或 BGM 切換邏輯
	# if GameManager.has_method("shake_screen"):
	#     GameManager.shake_screen(10, 0.5)
	
