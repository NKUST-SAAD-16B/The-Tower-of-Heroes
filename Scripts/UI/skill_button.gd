extends TextureButton

#能力數按鈕腳本
@export var skill_name : String
@export var texture : Texture2D
@export var cost : int

#技能的屬性增益，使用Resource類型的skill_stats資源來存儲技能的屬性增益數值
@export var skill_status : SkillStats

#能力按鈕的狀態，默認為false，表示能力未被啟用
@onready var button_state : bool = false:
    set(value):
        button_state = value
        $Panel.show_behind_parent = button_state

func _ready() -> void:
    #設置按鈕的紋理為指定的texture
    self.texture_normal = texture
    #連接按鈕的pressed信號到_on_button_pressed函數
    pressed.connect(_on_button_pressed)
    pass

func _on_button_pressed():
    #當按鈕被按下時，切換按鈕的狀態
    button_state = not button_state
    #在控制台輸出按鈕的名稱和當前狀態
    print("Button ", skill_name, " pressed. Current state: ", button_state)
    pass
