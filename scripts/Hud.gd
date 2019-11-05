extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var xp_progress = $MarginContainer/HBoxContainer/Bars/Experience/XPProgress;
onready var health_progress = $MarginContainer/HBoxContainer/Bars/Health/HealthProgress;
onready var xp_value = $MarginContainer/HBoxContainer/Bars/Experience/Count/Background/Number;
onready var health_value = $MarginContainer/HBoxContainer/Bars/Health/Count/Background/Number;


export var Increment = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health()
	update_xp()

func update_health():
	health_value.text = str(health_progress.value);

func update_xp():
	xp_value.text = str(xp_progress.value);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func increment(bar):
	if (bar.value == 100):
		return;
	elif (bar.value < 100):
		var new_progress = bar.value + Increment;
		if (new_progress >= 100):
			bar.value = 100;
			return;
		bar.value = new_progress;

func decrement(bar):
	if (bar.value == 0):
		return;
	elif (bar.value > 0):
		var new_progress = bar.value - Increment;
		if (new_progress <= 0):
			bar.value = 0;
			return;
		bar.value = new_progress;

func _input(event):
	if (event.is_action_released("health_add")):
		increment(health_progress);
		update_health()
	elif (event.is_action_released("xp_add")):
		increment(xp_progress);
		update_xp()
	elif (event.is_action_released("health_sub")):
		decrement(health_progress);
		update_health()
	elif (event.is_action_released("xp_sub")):
		decrement(xp_progress);
		update_xp()

