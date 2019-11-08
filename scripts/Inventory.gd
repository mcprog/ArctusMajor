extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Inventory

onready var grid: GridContainer = $Panel/VBoxContainer/GridContainer;

var Stacks: Dictionary = {
	Items.name_raw_iron: Items.StackDictionary.raw_iron.appropriate(25, 5),
	Items.name_iron_ingot: Items.StackDictionary.iron_ingot.appropriate(200, 7)
};
const SlotCount = 60;
var slots;

func show():
	get_tree().paused = true;
	visible = true;

func hide():
	get_tree().paused = false;
	visible = false;

func toggle():
	get_tree().paused = not get_tree().paused;
	visible = not visible;

# Called when the node enters the scene tree for the first time.
func _ready():
	slots = grid.get_children();
#	var b = 9
#	for i in range(test_items.size()):
#		if (test_items[i] != null):
#			set_slot(i, Items.Stack.new(test_items[i]))
	for i in Stacks:
		var stack = Stacks[i];
		set_slot(stack.slot, stack);
	
	Global.ActiveInventory = Stacks;

func set_slot(index: int, stack) -> void:
	slots[index].set_slot(stack);

func _input(event):
	if (event.is_action_released("inventory")):
		toggle();