extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var seed_edit = $HBoxContainer/VBoxContainer/HBoxContainer/Right/Seed;
onready var name_edit = $HBoxContainer/VBoxContainer/HBoxContainer/Right/Name;
onready var difficulty_option = $HBoxContainer/VBoxContainer/HBoxContainer/Right/Difficulty;
onready var edit = $HBoxContainer/VBoxContainer/Edit;
onready var validate = $HBoxContainer/VBoxContainer/Validate;
onready var generate = $HBoxContainer/VBoxContainer/Generate;

var validated_seed:int;

# Called when the node enters the scene tree for the first time.
func _ready():
	name_edit.text = Words.generate_name()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Validate_pressed():
	var new_seed = int(seed_edit.text);
	validated_seed = new_seed;
	seed_edit.text = str(new_seed);
	seed_edit.editable = false;
	name_edit.editable = false;
	difficulty_option.disabled = true;
	edit.text = "Edit";
	edit.disabled = false;
	generate.disabled = false;
	validate.disabled = true;


func _on_Edit_pressed():
	generate.disabled = true;
	validate.disabled = false;
	edit.text = "Editing";
	edit.disabled = true;
	seed_edit.editable = true;
	name_edit.editable = true;
	difficulty_option.disabled = false;


func _on_Generate_pressed():
	generate.disabled = true;
	Save.save_new_game(name_edit.text, validated_seed, difficulty_option.get_selected_id())
	get_tree().change_scene("res://scenes/GeneratorDefault.tscn");


func _on_Back_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn");
