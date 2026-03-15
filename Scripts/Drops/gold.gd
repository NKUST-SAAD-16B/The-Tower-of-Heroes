extends CharacterBody2D
class_name Gold



#金幣的初始速度和旋轉速度是隨機生成的，這樣每個金幣的掉落效果都會有所不同，增加遊戲的趣味性和真實感
@onready var angular_velocity = randf_range(-10, 10)

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#金幣的碰撞檢測區域
@onready var pickup_area = $Area2D

#飛向玩家狀態
var flying_to_player = false
#飛行的方向
var direction : Vector2
#目標玩家位置
var target_position: Vector2
    
func _ready() -> void:
    #當金幣生成時，給予一個隨機的初始速度，使其有一個自然的掉落效果
    velocity = Vector2(randf_range(-50, 50), randf_range(-150, -100))
    
    #剛生成的金幣會有一段時間無法被撿取，這樣可以避免玩家在金幣剛掉落時就立刻撿取，沒有掉落的感覺
    pickup_area.set_deferred("monitoring", false)
    pass

func _physics_process(delta: float) -> void:
    #如果金幣正在飛向玩家，則更新金幣的速度和位置
    if flying_to_player:
        velocity = direction * 200
        #當金幣接近玩家時，增加玩家金幣，並將金幣從場景中移除
        if position.distance_to(target_position) < 10 :
            PlayerData.gold_quantity += 1
            call_deferred("queue_free")
            
            
    
    if is_on_floor():
        #當金幣落地後，逐漸減少旋轉速度，直到停止旋轉
        angular_velocity = move_toward(angular_velocity, 0, 20 * delta)
        velocity.x = move_toward(velocity.x, 0, 100 * delta)
    else:
        #讓金幣在空中旋轉
        rotation += angular_velocity * delta
        #讓金幣緩慢下降，模擬掉落效果
        velocity.y += gravity * delta
    move_and_slide()





#當金幣生成後的一段時間，允許玩家撿取金幣，這樣可以增加掉落的真實感
func _on_timer_timeout() -> void:
    print("金幣可以被撿取了")
    pickup_area.set_deferred("monitoring", true)
    pass # Replace with function body.

#當玩家的pickup_area檢測到金幣時，觸發這個函數，開始讓金幣飛向玩家
func _on_area_2d_area_entered(area:Area2D) -> void:
    if area.name == "PickUp":
        print("金幣被撿取")
        flying_to_player = true
        target_position = area.global_position
        direction = (target_position - position).normalized()



func _on_area_2d_area_exited(area:Area2D) -> void:
    flying_to_player = false
    #當玩家離開金幣的檢測區域時，停止金幣飛向玩家，並將金幣的速度重置為0，這樣可以避免金幣在玩家離開後繼續飛行
    velocity = Vector2.ZERO
    print("玩家離開檢測區域")


