extends Node2D

var speed = 100.0
var direction = Vector2(1, 0)
var window_size = Vector2(800, 600)
var coins: int = 0
var coin_manager: Node

var idle_timer: float = 0.0
var next_idle_check: float = 3.0
var is_idle: bool = false

@onready var otter_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	otter_sprite.play("walk")
	otter_sprite.add_to_group("otter_player")
	add_to_group("game_manager")

	coin_manager = get_tree().get_first_node_in_group("coin_manager")


func _physics_process(delta: float) -> void:
	if is_instance_valid(coin_manager) and coin_manager.coin.visible:
		is_idle = false

		if otter_sprite.animation != "walk":
			otter_sprite.play("walk")

		var coin_position = coin_manager.coin.global_position
		var distance = otter_sprite.global_position.distance_to(coin_position)

		if distance > 25.0:
			var target_direction = (
				coin_position - otter_sprite.global_position
			).normalized()

			otter_sprite.global_position += target_direction * speed * delta
			otter_sprite.flip_h = target_direction.x < 0
		else:
			coin_manager.collect_coin()
		return
		
	if is_idle:
		return

	var otter_position = otter_sprite.position
	otter_position += direction * speed * delta

	otter_position.x = clamp(otter_position.x, 80, window_size.x - 50)
	otter_position.y = clamp(otter_position.y, 80, window_size.y - 50)

	if otter_position.x >= window_size.x - 80 and direction.x > 0:
		direction = Vector2(0, 1)
		otter_sprite.flip_h = false

	elif otter_position.y >= window_size.y - 80 and direction.y > 0:
		direction = Vector2(-1, 0)
		otter_sprite.flip_h = true

	elif otter_position.x <= 80 and direction.x < 0:
		direction = Vector2(0, -1)
		otter_sprite.flip_h = false

	elif otter_position.y <= 80 and direction.y < 0:
		direction = Vector2(1, 0)
		otter_sprite.flip_h = false

	otter_sprite.position = otter_position


func _process(delta: float) -> void:
	if is_idle:
		idle_timer -= delta
		if idle_timer <= 0.0:
			is_idle = false
			otter_sprite.play("walk")
	else:
		next_idle_check -= delta
		if next_idle_check <= 0.0:
			next_idle_check = randf_range(3.0, 6.0)
			if randf() < 0.3:
				is_idle = true
				idle_timer = randf_range(2.0, 4.0)
				otter_sprite.play("idle")

func add_coins(amount: int) -> void:
	coins += amount
	print("Coins:", coins)
