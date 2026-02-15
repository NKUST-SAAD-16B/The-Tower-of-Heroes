extends Control

# 商店菜單，顯示三張隨機命運卡，玩家可以選擇其中一張來應用其效果

#暫存當前顯示的命運卡數據
var current_card : Array = []

func _ready() -> void:
	#進入商店時隨機生成3張命運卡
	for i in range(3):
		#從DestinyManager獲取隨機命運卡
		var destiny = DestinyManager.destiny_random()
		var card = $HBoxContainer.get_node("Card" + str(i + 1))
		card.get_node("VBoxContainer/Title").text = destiny.title
		card.get_node("VBoxContainer/ScrollContainer/Description").text = destiny.description
		current_card.append(destiny)
	pass




func _on_card_1_pressed() -> void:
	DestinyManager.destiny_apply(current_card[0])
	pass # Replace with function body.


func _on_card_2_pressed() -> void:
	DestinyManager.destiny_apply(current_card[1])
	pass # Replace with function body.


func _on_card_3_pressed() -> void:
	DestinyManager.destiny_apply(current_card[2])
	pass # Replace with function body.
