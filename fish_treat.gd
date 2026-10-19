extends Sprite2D

const FISH_PRICE: int = 3
const PICKUP_DISTANCE: float = 35.0

var coin_manager: Node
var otter: Node2D
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var is_being_eaten: bool = false

var middle_position: Vector2

func _ready() -> void:
	coin_manager = get_tree().get_first_node_in_group("coin_manager")
	otter = get_tree().get_first_node_in_group("otter_player") as Node2D
	
	middle_position = get_viewport_rect().size / 2.0
	global_position = middle_position
	show()
	
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		return
	if is_being_eaten:
		return
	if not visible:
		if is_instance_valid(coin_manager) and coin_manager.coins >= FISH_PRICE:
			global_position = middle_position
			show()
		else:
			return
	if not is_instance_valid(coin_manager) or not is_instance_valid(otter):
		return
	if global_position.distance_to(otter.global_position) <= PICKUP_DISTANCE:
		if coin_manager.coins < FISH_PRICE:
			hide()
			return
			
		is_being_eaten = true
		
		if coin_manager.spend_coins(FISH_PRICE):
			print("Otter bought a fish treat!")
			await get_tree().create_timer(0.5).timeout
			
			if coin_manager.coins >= FISH_PRICE:
				global_position = middle_position
				show()
			else:
				hide()
		is_being_eaten = false
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if visible and not is_being_eaten:
					var mouse_pos = to_local(get_global_mouse_position())
					if get_rect().has_point(mouse_pos):
						is_dragging = true
						drag_offset = global_position - get_global_mouse_position()
						get_viewport().set_input_as_handled()
			else:
				is_dragging = false

	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position() + drag_offset
