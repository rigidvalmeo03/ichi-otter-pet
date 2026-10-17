extends Node2D

var speed = 100.0
var direction = Vector2(1,0)
var window_size = Vector2(800,600)

@onready var otter_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	otter_sprite.play("walk")

func _physics_process(delta: float) -> void:
	var otter_position = otter_sprite.position
	otter_position += direction * speed * delta
	
	otter_position.x = clamp(otter_position.x, 80, window_size.x - 50)
	otter_position.y = clamp(otter_position.y, 80, window_size.y - 50)
	
	if otter_position.x >= window_size.x - 80 and direction.x > 0:
		direction = Vector2(0,1)
		otter_sprite.flip_h = false
		#dipako tapos ok
