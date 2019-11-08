extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var quit = $Panel/VBoxContainer/Quit;
onready var resume = $Panel/VBoxContainer/Resume;
onready var savename = $Panel/VBoxContainer/SaveName;

# Called when the node enters the scene tree for the first time.
func _ready():
	savename.text = Global.ActiveName;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if (event.is_action_released("pause")):
		visible = !visible;
		get_tree().paused = !get_tree().paused;

func _on_Resume_pressed():
	visible = false;
	get_tree().paused = false;


func _on_Quit_pressed():
	
	get_tree().change_scene("res://scenes/StartMenu.tscn");
	get_tree().paused = false;


func _on_Save_pressed():
	Save.save_active_game()
	print(Save.save_inventory());




func _on_Load_pressed():
	pass # Replace with function body.
