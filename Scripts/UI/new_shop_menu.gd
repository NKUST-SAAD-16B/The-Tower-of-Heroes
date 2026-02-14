extends Control

func _ready() -> void:
	#進入商店時隨機生成3張命運卡
	for i in range(3):
		#從DestinyManager獲取隨機命運卡
		var destiny = DestinyManager.destiny_random()
		var card = $HBoxContainer.get_node("Card" + str(i + 1))
		card.get_node("VBoxContainer/Title").text = destiny.title
		card.get_node("VBoxContainer/ScrollContainer/Description").text = destiny.description
	pass




func _on_card_1_pressed() -> void:
	
	pass # Replace with function body.


func _on_card_2_pressed() -> void:
	pass # Replace with function body.


func _on_card_3_pressed() -> void:
	pass # Replace with function body.
