extends TextureButton

onready var icon = $TextureRect;
onready var count = $Count;

func set_slot(stack) -> void:
	stack.item.set_up();
	icon.texture = stack.item.texture;
	icon.hint_tooltip = stack.item.Name;
	count.text = str(stack.count);