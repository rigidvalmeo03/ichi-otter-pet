extends Sprite2D

const PICKUP_DISTANCE: float = 100.0

@export var item_value: int = 5

@onready var area: Area2D = $Area2D

var otter: AnimatedSprite2D
var manager: Node

var is_dragging: bool = false
var is_carried: bool = false
var is_sold: bool = false
var is_showing_choice: bool = false

var drag_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	area.input_pickable = true
	area.input_event.connect(_on_area_input_event)

	otter = get_tree().get_first_node_in_group(
        "otter_player"
	) as AnimatedSprite2D

	manager = get_tree().get_first_node_in_group(
        "coin_manager"
	)


func _process(_delta: float) -> void:
	if is_sold:
		return

	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		return

	if not is_instance_valid(otter):
		return

	if is_carried:
		var carry_offset = Vector2(20, -15)

		if otter.flip_h:
			carry_offset.x = -20

		global_position = otter.global_position + carry_offset
	elif global_position.distance_to(otter.global_position) <= PICKUP_DISTANCE:
		is_carried = true


func _on_area_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if is_sold or is_showing_choice:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_carried:
				_show_item_choice()
			else:
				is_dragging = true
				drag_offset = global_position - get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false


func _show_item_choice() -> void:
	is_showing_choice = true

	var dialog = ConfirmationDialog.new()
	dialog.title = "What should happen to the item?"
	dialog.dialog_text = "Buy this item for %d coin(s)?" % item_value
	dialog.ok_button_text = "Buy"
	dialog.cancel_button_text = "Return"

	get_tree().root.add_child(dialog)
	dialog.exclusive = false

	dialog.confirmed.connect(_sell_item)
	dialog.canceled.connect(_return_item)
	dialog.close_requested.connect(_return_item)

	dialog.popup_centered()


func _sell_item() -> void:
	if is_sold:
		return

	is_sold = true
	is_carried = false
	is_dragging = false
	is_showing_choice = false

	if is_instance_valid(manager):
		manager.spawn_coin(global_position, item_value)

	hide()
	area.input_pickable = false


func _return_item() -> void:
	if is_sold:
		return

	is_carried = false
	is_dragging = false
	is_showing_choice = false
