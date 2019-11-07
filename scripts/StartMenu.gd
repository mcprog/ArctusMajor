extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var resume:Button = $HBoxContainer/VBoxContainer/Resume;
onready var load_button:Button = $HBoxContainer/VBoxContainer/Load;

var latest_save;

# Called when the node enters the scene tree for the first time.
func _ready():
	Save.init_save_filenames();
	for f in Save.savenames:
		print_debug(f);
	if (Save.savenames.size() != 0):
		Save.load_all_saves();
		Save.present_save_data();
		latest_save = Save.saves[0];
		
		resume.disabled = false;
		resume.hint_tooltip = latest_save.Name;
		load_button.disabled = false;
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://scenes/NewGame.tscn");


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	Global.ActiveFilename = latest_save.filename;
	Global.ActiveDatetime = latest_save.date_fmt;
	Global.ActiveDifficulty = latest_save.difficulty;
	Global.ActiveName = latest_save.Name;
	Global.ActiveSeed = latest_save.Seed;
	get_tree().change_scene("res://scenes/GeneratorDefault.tscn");


func _on_Load_pressed():
	get_tree().change_scene("res://scenes/LoadGame.tscn");
