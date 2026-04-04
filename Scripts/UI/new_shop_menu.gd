extends Control

# 商店菜單，顯示三張隨機命運卡，玩家可以選擇其中一張來應用其效果

#暫存當前顯示的命運卡數據
var current_card : Array = []

#卡片選擇完成後發出信號，通知world.gd繼續遊戲
signal card_selected

#卡片按鈕節點
@onready var card_1 : TextureButton = $HBoxContainer/Card1
@onready var card_2 : TextureButton = $HBoxContainer/Card2
@onready var card_3 : TextureButton = $HBoxContainer/Card3

func _ready() -> void:
	# 初始隱藏
	self.hide()

# 每次顯示時調用此函數來生成新卡片
func generate_cards() -> void:
	# 清空舊數據
	current_card.clear()
	var selected_keys = []
	
	#開啟按鈕
	card_1.disabled = false
	card_2.disabled = false
	card_3.disabled = false
	
	# 隨機生成 3 張命運卡
	for i in range(3):
		# 傳入已選 Key 確保不重複
		var destiny = DestinyManager.destiny_random(selected_keys)
		
		# 如果沒剩餘可用卡片則跳出
		if destiny.is_empty():
			break
			
		selected_keys.append(destiny.key)
		
		var card = $HBoxContainer.get_node("Card" + str(i + 1))
		card.get_node("VBoxContainer/Title").text = destiny.title
		card.get_node("VBoxContainer/ScrollContainer/Description").text = destiny.description
		card.get_node("VBoxContainer/Icon").texture = load(destiny.icon)
		current_card.append(destiny)

# 覆蓋 show 函數或提供一個專門的開啟函數
func open_shop() -> void:
	generate_cards()
	self.show()

func _on_card_1_pressed() -> void:
	if current_card.size() > 0:
		DestinyManager.destiny_apply(current_card[0])
		selected()


func _on_card_2_pressed() -> void:
	if current_card.size() > 1:
		DestinyManager.destiny_apply(current_card[1])
		selected()


func _on_card_3_pressed() -> void:
	if current_card.size() > 2:
		DestinyManager.destiny_apply(current_card[2])
		selected()

#選擇命運卡後的處理函數，發出card_selected信號並隱藏商店菜單
func selected() -> void:
	#所有按鈕在選擇後都不可再被點擊，避免重複選擇
	card_1.disabled = true
	card_2.disabled = true
	card_3.disabled = true
	#向下移動商店菜單以實現滑出動畫
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position", Vector2(self.position.x, self.size.y), 1.0)
	#等待動畫完成後才執行後續程式碼
	await tween.finished

	#發出card_selected信號，通知world.gd
	card_selected.emit()
	self.hide()
