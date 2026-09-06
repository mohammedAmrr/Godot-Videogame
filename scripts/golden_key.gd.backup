extends RigidBody3D

# We need a reference to the ItemData for this object
@export var item_data: ItemData # This should be an ItemData resource

func _ready() -> void:
	add_to_group("interactable")

func collect():
	if Inventory.add_item(item_data):
		call_deferred("queue_free")
	else:
		pass
