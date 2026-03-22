extends PanelContainer
@onready var title_label : Label = $MarginContainer/VBoxContainer/Title
@onready var description_label : Label = $MarginContainer/VBoxContainer/Description
@onready var cost_label : Label = $MarginContainer/VBoxContainer/Cost

func setup(title: String, description: String, cost: int) -> void:
	if not is_node_ready():
		print("Tooltip not ready yet. Delaying setup.")
		await self.ready
	title_label.text = title
	description_label.text = description
	cost_label.text = "金幣花費: " + str(cost)
	if cost <= PlayerData.gold_quantity:
		cost_label.add_theme_color_override("font_color",Color(1, 1, 0))#黃色
	else:
		cost_label.add_theme_color_override("font_color", Color(1, 0, 0)) # 紅色
