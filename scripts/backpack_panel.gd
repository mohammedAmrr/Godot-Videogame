extends CanvasLayer

var _slot_buttons : Array = []

func _ready() -> void:
	self.hide()
	_create_slots()
	_update_slots()
	Inventory.inventory_changed.connect(_update_slots)
	Inventory.backpack_slot_selected.connect(_on_backpack_slot_selected)

func _create_slots() -> void:
	var container = self.get_node("SlotsContainer")
	var slot_scene = preload("res://scenes/inventory_slot.tscn")
	for i in 16: # NOTE: we only show first 16 slots; could be extended but UI limited
		var slot_instance = slot_scene.instantiate()
		var slot_button = slot_instance as TextureButton
		slot_button.name = str(i) # store index as name
		slot_button.pressed.connect(_on_slot_button_pressed.bind(i))
		container.add_child(slot_instance)
		_slot_buttons.append(slot_button)

func _update_slots() -> void:
	var container = self.get_node("SlotsContainer")
	for i in container.get_child_count():
		var slot_instance = container.get_child(i)
		var slot_btn = slot_instance as TextureButton
		var label = slot_instance.get_node("CountLabel") as Label
		if i < Inventory.backpack.size():
			var data = Inventory.backpack[i]
			if slot_btn:
				slot_btn.texture_normal = data.item.icon if data.item != null and data.item.icon != null else null
			if label:
				if data.count > 1:
					label.text = str(data.count)
					label.show()
				else:
					label.hide()
		else:
			if slot_btn:
				slot_btn.texture_normal = null
			if label:
				label.hide()
	_update_highlight()

func _on_slot_button_pressed(slot_index: int) -> void:
	Inventory.select_backpack_slot(slot_index)

func _on_backpack_slot_selected(slot_index: int) -> void:
	_update_highlight()

func _update_highlight() -> void:
	# reset all
	for btn in _slot_buttons:
		btn.modulate = Color(1,1,1)
	# highlight selected if within shown range (0-15)
	var idx = Inventory.selected_backpack_index
	if idx < _slot_buttons.size():
		_slot_buttons[idx].modulate = Color(1.5,1.5,1.5)