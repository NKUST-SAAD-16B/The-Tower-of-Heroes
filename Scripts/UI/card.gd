extends TextureButton

@onready var border: NinePatchRect = $MarginContainer/Border

func _ready() -> void:
	border.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pass

func _on_mouse_entered():
	border.show()
	pass

func _on_mouse_exited():
	border.hide()
	pass
