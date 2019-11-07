extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var save_list: ItemList = $HBoxContainer/VBoxContainer/SaveList;
onready var load_button: Button = $HBoxContainer/VBoxContainer/Load;

var selected: int;

onready var name_value: LineEdit = $HBoxContainer/MarginContainer/Details/HBoxContainer/Values/Name;
onready var seed_value: LineEdit = $HBoxContainer/MarginContainer/Details/HBoxContainer/Values/Seed;
onready var difficulty_value: LineEdit = $HBoxContainer/MarginContainer/Details/HBoxContainer/Values/Difficulty;
onready var modified_value: LineEdit = $HBoxContainer/MarginContainer/Details/HBoxContainer/Values/Modified;

# Called when the node enters the scene tree for the first time.
func _ready():
	#Save.init_save_filenames();
	#Save.load_all_saves()
	
	for i in range(Save.saves.size()):
		var current = Save.saves[i];
		save_list.add_item(current.Name);
		#save_list.get_children()[0].get_children()[0].align = Button.ALIGN_CENTER



func _on_SaveList_item_selected(index):
	load_button.disabled = false;
	selected = index;
	var data = Save.saves[selected];
	name_value.text = data.Name;
	seed_value.text = str(data.Seed);
	difficulty_value.text = Save.get_difficulty_str(data.difficulty);
	modified_value.text = data.date_fmt;

func _on_Load_pressed():
	var data = Save.saves[selected];
	Global.ActiveFilename = data.filename;
	Global.ActiveDatetime = data.date_fmt;
	Global.ActiveDifficulty = data.difficulty;
	Global.ActiveName = data.Name;
	Global.ActiveSeed = data.Seed;
	get_tree().change_scene("res://scenes/GeneratorDefault.tscn");
