extends TextureButton

#能力數按鈕腳本
@export var skill_name : String
@export var texture : Texture2D
@export var cost : int
@export_multiline var description : String
@export var skill_type : String
#能力按鈕的父節點，默認為null，表示沒有父節點
@export var parent : TextureButton
#能力的層級
@export var order : int
#能力按鈕的tooltip
@export var tooltip : PackedScene = preload("res://Scenes/UI/SkillTreeTooltip.tscn")
#當能力按鈕被按下時，發出skill_button_pressed信號，並將技能名稱作為參數傳遞
signal skill_button_pressed(button_node:TextureButton)

#技能的屬性增益，使用Resource類型的skill_stats資源來存儲技能的屬性增益數值
@export var skill_status : SkillStats

#能力按鈕的狀態，默認為false，表示能力未被啟用
@onready var button_state : bool = false:
	set(value):
		button_state = value
		if button_state:
			$Panel.show_behind_parent = true
			

func _ready() -> void:
	#設置按鈕的紋理為指定的texture
	self.texture_normal = texture
	#連接按鈕的pressed信號到_on_button_pressed函數
	pressed.connect(_on_button_pressed)
	#將tooltip_text設置為空字符串，以便使用自定義的tooltip
	self.tooltip_text = "" 
	pass

#當按鈕被按下時，切換按鈕為true，表示能力被啟用
func _on_button_pressed():
	#檢查玩家的金幣數量是否足夠支付能力的成本
	if PlayerData.gold_quantity >= cost:
		PlayerData.gold_quantity -= cost
		#當按鈕被按下時，切換按鈕的狀態
		button_state = true
		#已啟用能力後，禁用按鈕以防止再次按下
		disabled = true

		PlayerData.skill_status_apply(skill_status)
		
		#在控制台輸出按鈕的名稱和當前狀態
		print("Button ", skill_name, " pressed. Current state: ", button_state)

		#輸出所有玩家數據的當前值，以驗證技能屬性增益是否正確應用
		print("Player Max Health: ", PlayerData.player_max_health)
		print("Player Base Damage: ", PlayerData.player_base_damage)
		print("Player Critical Chance: ", PlayerData.player_critical_chance)
		print("Player Critical Multiplier: ", PlayerData.player_critical_multiplier)
		print("Player Walk Speed: ", PlayerData.player_walk_speed)
		print("Player Run Speed: ", PlayerData.player_run_speed)
		print("Player Gold Quantity: ", PlayerData.gold_quantity)
		skill_button_pressed.emit(self)
	else:
		print("金幣不足，無法啟用能力。")
	pass

func _make_custom_tooltip(for_text: String) -> Control:
	var tooltip_instance = tooltip.instantiate()
	tooltip_instance.setup(skill_name, description, cost)
	return tooltip_instance
