extends HBoxContainer

var slots : Array

func _ready() -> void:
	get_slots()
	Inventory.inventory_changed.connect(_update_hotbar)
	Inventory.slot_selected.connect(highlight_slot)
	_update_hotbar()

func get_slots():
	slots = get_children()
	for slot : TextureButton in slots:
		slot.pressed.connect(Inventory.select_slot.bind(slot.get_index()))

func _update_hotbar() -> void:
	for slot_node in slots:
		var slot_index = slot_node.get_index()
		if slot_index < Inventory.hotbar.size():
			var slot = Inventory.hotbar[slot_index]
			var label = slot_node.get_node("CountLabel")
			if slot.item != null:
				slot_node.texture_normal = slot.item.icon
				label.text = str(slot.count)
				label.show()
			else:
				slot_node.texture_normal = null
				label.hide()

func highlight_slot(slot_index: int):
	for i in range(4):
		slots[i].modulate = Color(1,1,1)
	slots[slot_index].modulate = Color(1.5,1.5,1.5)
