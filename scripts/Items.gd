extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Item:
	var texture_path: String;
	var texture: Texture = null;
	var Name: String;
	
	func _init(n: String, p: String):
		texture_path = p;
		Name = n;
	
	func to_str() -> String:
		return Name + "/" + texture_path;
	
	func set_up():
		if (texture == null):
			texture = load("res://textures/" + texture_path + ".png");

const MaxStack = 9001;

class Stack:
	var item: Item;
	var count: int;
	var slot: int;
	
	func _init(i: Item, c: int = 1, s: int = 0):
		item = i;
		count = c;
		slot = s;
		
	func appropriate(c: int, s: int) -> Stack:
		var ret: Stack = Stack.new(item, c, s);
		return ret;
	
	func to_str() -> String:
		return str(count) + " " + item.Name + " @ " + str(slot);
	
	func to_save() -> String:
		return item.texture_path + " " + str(count) + " " + str(slot);
	
	func decrease(amt: int) -> bool:
		var new_count = count - amt;
		if (new_count < 0):
			return false;
		count = new_count;
		return true;
	
	func increase(amt: int) -> bool:
		var new_count = count + amt;
		if (new_count > MaxStack):
			return false;
		count = new_count;
		return true;
	
var name_raw_iron = "raw_iron";
var name_iron_ingot = "iron_ingot";

var raw_iron = Item.new("Raw Iron", name_raw_iron);
var iron_ingot = Item.new("Iron Ingot", name_iron_ingot)

var ItemsDictionary = {
	name_raw_iron: raw_iron,
	name_iron_ingot: iron_ingot
}

# Do not use these stacks directly, use the appropriate() function to get a copy of a stack
var StackDictionary = {
	name_raw_iron: Stack.new(raw_iron),
	name_iron_ingot: Stack.new(iron_ingot)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(ItemsDictionary["raw_iron"].to_str());

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
