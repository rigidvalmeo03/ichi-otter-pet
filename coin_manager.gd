extends Node

var coins: int = 0
var coin_icons: Array[Sprite2D] = []

@export var coin_texture: Texture2D = preload("res://pictures/coin.png")

const START_POSITION := Vector2(30, 30)
const COIN_SPACING := 24.0
const COIN_SCALE := Vector2(0.25, 0.25)

func _ready() -> void:
	add_to_group("coin_manager")
	update_coin_display()

func spawn_coin(_item_position: Vector2, value: int) -> void:
	coins += value
	update_coin_display()
	print("Coins: ", coins)
	
func spend_coins(amount: int) -> bool:
	if coins < amount: 
		return false
		
	coins -= amount
	update_coin_display()
	print("Coins: ", coins)
	return true

func update_coin_display() -> void:
	for icon in coin_icons:
		icon.queue_free()
	coin_icons.clear()

	for i in range(coins):
		var coin_icon := Sprite2D.new()
		coin_icon.texture = coin_texture
		coin_icon.position = START_POSITION + Vector2(i * COIN_SPACING, 0)
		coin_icon.scale = COIN_SCALE
		add_child(coin_icon)
		coin_icons.append(coin_icon)
