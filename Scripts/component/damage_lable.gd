extends Marker2D

@onready var label: Label = $Label
func _ready():
    # 隨機化彈跳方向
    var spread = 20 # 彈跳範圍
    var random_x = randf_range(-spread, spread)
    var target_pos = position + Vector2(random_x, -30) # 往上飄

    # 建立Tween動畫
    var tween = create_tween().set_parallel(true)

	# 位移動畫：往隨機上方飄移
    tween.tween_property(self, "position", target_pos, 0.5)
    tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

    # 縮放動畫：先變大再縮小 (打擊感)
    scale = Vector2.ZERO
    tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.1)
    tween.chain().tween_property(self, "scale", Vector2(0.2, 0.2), 0.2)
	
	# 透明度動畫：最後淡出
    tween.chain().tween_property(self, "modulate:a", 0, 0.3)

    # 動畫結束後自動銷毀
    tween.finished.connect(queue_free)

func _damage_label(damage_value: int):
    # 這裡可以添加額外的邏輯，例如根據傷害值改變顏色或文字內容
    label.text = str(damage_value)