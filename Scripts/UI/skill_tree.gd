extends Control
class_name SkillTree
#技能樹腳本
@onready var gold_quantity_label : Label = $HBoxContainer/GoldQuantity

#繼續前往下一層的按鈕
@onready var continue_button : Button = $ContinueButton

signal continue_to_next_floor
func _ready() -> void:
	#連接所有技能按鈕的skill_button_pressed信號到_on_skill_button_pressed函數
	for button in get_tree().get_nodes_in_group("skill_buttons"):
		if not button.skill_button_pressed.is_connected(enable_next_button):
			button.skill_button_pressed.connect(enable_next_button)

	#連接玩家數據的gold_quantity_changed信號到_on_gold_quantity_changed函數，以便在金幣數量變化時更新UI顯示
	if not PlayerData.gold_quantity_changed.is_connected(_on_gold_quantity_changed):
		PlayerData.gold_quantity_changed.connect(_on_gold_quantity_changed)


	gold_quantity_label.text = str(PlayerData.gold_quantity)    
	pass

#啟用下個能力按鈕的函數，將當前按鈕的狀態設置為false，並啟用下一個按鈕
func enable_next_button(button_node:TextureButton) -> void:
	print("啟用能力按鈕: ", button_node.name)
	#改變line2D的顏色為黃色，連接到下個能啟用的按鈕
	for child in button_node.get_children():
		if child is Line2D:
			child.default_color = Color(250,203,0,255)
	
	for button in get_tree().get_nodes_in_group("skill_buttons"):
		#檢查按鈕的父節點是否為當前按鈕，如果是，則啟用該按鈕
		if button.parent == button_node:
			button.disabled = false
			print("啟用按鈕: ", button.name)
			
func _on_gold_quantity_changed():
	gold_quantity_label.text = str(PlayerData.gold_quantity)

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	#繼續前往下一層的按鈕被按下後，隱藏技能樹界面並觸發房間過渡
	self.hide()
	continue_to_next_floor.emit()
	pass
