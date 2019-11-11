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
	Stacks = Global.ActiveInventory;
	
	for i in Stacks:
		var stack = Stacks[i];
		set_slot(stack.slot, stack);
	
	#Global.ActiveInventory = Stacks;

func set_slot(index: int, stack) -> void:
	slots[index].set_slot(stack);

func update_slot(stack) -> void:
	slots[stack.slot].set_slot(stack);

func add_drop(drop: Drop):
	var path = drop.texture_path;
	var count = drop.count;
	for i in Stacks:
		if (Stacks[i].item.texture_path == path):
			
			Stacks[i].increase(count);
			update_slot(Stacks[i]);
			return;
	var new_stack = Items.StackDictionary[path].appropriate(count, Stacks.size());
	Stacks[path] = new_stack;
	set_slot(Stacks.size() - 1, Stacks[path]);

func _input(event):
	if (event.is_action_released("inventory")):
		toggle();