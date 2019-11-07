extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var save_list: ItemList = $Panel/VBoxContainer/SaveList;
onready var load_button: Button = $Panel/VBoxContainer/Load;

var selected: int;

# Called when the node enters the scene tree for the first time.
func _ready():
	#Save.init_save_filenames();
	#Save.load_all_saves()
	for i in range(Save.saves.size()):
		var current = Save.saves[i];
		save_list.add_item(current.Name + "    seed: " + str(current.Seed) + "    difficulty: " + Save.get_difficulty_str(current.difficulty));
		save_list.set_item_tooltip(i, "modified: " + current.date_fmt);



func _on_SaveList_item_selected(index):
	load_button.disabled = false;
	selected = index;

func _on_Load_pressed():
	var data = Save.saves[selected];
	Global.ActiveFilename = data.filename;
	Global.ActiveDatetime = data.date_fmt;
	Global.ActiveDifficulty = data.difficulty;
	Global.ActiveName = data.Name;
	Global.ActiveSeed = data.Seed;
	get_tree().change_scene("res://scenes/GeneratorDefault.tscn");
