extends Node

signal inventory_changed
signal slot_selected(slot_index: int)
signal item_drop(item)
var selected_slot_index := 0
class Slot:
	var item: ItemData
	var count: int = 0

	func __init__(i: ItemData = null, c: int = 0):
		item = i
		count = c

const HOTBAR_SIZE := 4
var hotbar: Array[Slot]
var selected_slot: int = 0

func _init() -> void:
	for i in HOTBAR_SIZE:
		hotbar.append(Slot.new())

func add_item(item: ItemData, amount: int = 1) -> bool:
	# Try to stack first
	for slot in hotbar:
		if slot.item == item:
			slot.count += amount
			inventory_changed.emit()
			return true

	# Try to find empty slot
	for i in HOTBAR_SIZE:
		if hotbar[i].item == null:
			hotbar[i].item = item
			hotbar[i].count = amount
			inventory_changed.emit()
			slot_selected.emit(i)
			return true
	return false

func drop_item(index: int) -> ItemData:
	if index < 0 or index >= HOTBAR_SIZE:
		return null

	var slot = hotbar[index]
	if slot.item == null:
		return null

	var item_to_drop = slot.item
	slot.count -= 1

	if slot.count <= 0:
		slot.item = null
		slot.count = 0

	inventory_changed.emit()
	return item_to_drop

func select_slot(index: int):
	selected_slot = clamp(index, 0, HOTBAR_SIZE - 1)
	slot_selected.emit(selected_slot)
