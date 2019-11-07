extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var grid: GridContainer = $Panel/VBoxContainer/GridContainer;

var Stacks: Array = [];
const SlotCount = 60;
var slots;

var test_items = [
	null,
	Items.iron_ingot,
	Items.raw_iron
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Stacks.resize(SlotCount);
	slots = grid.get_children();
	
	for i in range(test_items.size()):
		if (test_items[i] != null):
			set_slot(i, Items.Stack.new(test_items[i]))

func set_slot(index: int, stack) -> void:
	slots[index].set_slot(stack);
