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
	
	func _init(i: Item, c: int = 1):
		item = i;
		count = c;
	
	
	func to_str() -> String:
		return str(count) + " " + item.Name;
	
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
	

var raw_iron = Item.new("Raw Iron", "raw_iron");
var iron_ingot = Item.new("Iron Ingot", "iron_ingot")


# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(iron_ingot.to_str());

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
