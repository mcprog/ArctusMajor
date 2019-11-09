extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Direction {
	South, West, North, East
}

enum Animation {
	Idle, Walking
}

onready var xp_progress = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Bars/Experience/XPProgress;
onready var health_progress = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Bars/Health/HealthProgress;
onready var xp_value = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Bars/Experience/Count/Background/Number;
onready var health_value = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Bars/Health/Count/Background/Number;
onready var level_value = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Counters/Level/Background/Number;
onready var bullet_value = $CanvasLayer/Hud/MarginContainer/HBoxContainer/Counters/Bullets/Background/Number;
onready var camera = $Camera2D;
onready var drop_range = $DropRange;

onready var inventory: Inventory = $CanvasLayer/Inventory;

export(Direction) var direction  = Direction.South; 
export var max_zoom = Vector2(1, 1);
export var speed = 30.0;

var audio;
var shoot_audio;
var animator;
var walking;
var x_axis = 0;
var y_axis = 0;
var velocity = Vector2.ZERO
var audio_position;
var Bullet = preload("res://scenes/Bullet.tscn");

const Cooldown = 0.8;
var shoot_timer = 0.0;
export var Increment = 5;
var level = 1;
var bullets = 250;

var movement_locked = false;
var zooming = false;
var default_zoom: Vector2;


# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("WalkSound");
	shoot_audio = get_node("ShootSound");
	animator = get_node("AnimationPlayer");
	audio_position = 0.0;
	walking = false;
	face_direction(direction);
	update_health()
	update_xp()
	default_zoom = camera.zoom;

func spawn_at(vect):
	position = vect;

func face_direction(new_direction):
	direction = new_direction;
	rotation_degrees = 90 * direction;

func walk(walk_direction):
	face_direction(walk_direction);
	walking = true;
	
func retrospect_direction():
	if (y_axis == -1):
		face_direction(Direction.North);
	elif (x_axis == -1):
		face_direction(Direction.West);
	elif (y_axis == 1):
		face_direction(Direction.South);
	elif (x_axis == 1):
		face_direction(Direction.East);

func animate(type):
	if (type == Animation.Walking):
		animator.play("walk");
	else:
		animator.play("idle");

func shoot():
	if (shoot_timer > 0.0 or bullets <= 0):
		return
	shoot_timer = Cooldown
	
	var bullet = Bullet.instance();
	bullet.start(position, direction * 90)
	get_parent().add_child(bullet);
	shoot_audio.play();
	bullets -= 1;
	bullet_value.text = str(bullets);
	

func update_level():
	level_value.text = str(level);

func update_health():
	health_value.text = str(health_progress.value);

func update_xp():
	xp_value.text = str(xp_progress.value);

func handle_zoom(delta):
	if (zooming and camera.zoom < max_zoom):
		camera.zoom.x += delta;
		camera.zoom.y += delta;
	elif (not zooming):
		if (camera.zoom > default_zoom):
			camera.zoom.x -= delta;
			camera.zoom.y -= delta;
		else:
			camera.zoom = default_zoom;
			movement_locked = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func increment(bar):
	if (bar.value == 100):
		bar.value = Increment;
		level += 1;
		update_level();
		return;
	elif (bar.value < 100):
		var new_progress = bar.value + Increment;
		if (new_progress == 100):
			bar.value = new_progress;
			return;
		elif (new_progress >= 100):
			bar.value = new_progress - bar.value; # experience does not wrap
			level += 1;
			update_level();
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y = y_axis;
	velocity.x = x_axis;
	velocity *= speed;
	if (not movement_locked):
		move_and_slide(velocity);
	if (shoot_timer > 0.0):
		shoot_timer -= delta;
	
	if (y_axis == 0 and x_axis == 0):
		animate(Animation.Idle);
		if (audio.playing):
			audio_position = audio.get_playback_position()
			audio.stop()
	else:
		animate(Animation.Walking);
		if (not audio.playing):
			audio.play(audio_position)
	handle_zoom(delta);

func _input(event):
	if (event.is_action_pressed("south")):
		y_axis += 1
		face_direction(Direction.South)
	elif (event.is_action_pressed("west")):
		x_axis -= 1
		face_direction(Direction.West)
	elif (event.is_action_pressed("north")):
		y_axis -= 1
		face_direction(Direction.North)
	elif (event.is_action_pressed("east")):
		x_axis += 1
		face_direction(Direction.East)
	elif (event.is_action_pressed("shoot")):
		shoot()
	elif (event.is_action_pressed("zoom")):
		zooming = true;
		movement_locked = true;
	elif (event.is_action_released("south")):
		y_axis -= 1;
		retrospect_direction()
	elif (event.is_action_released("west")):
		x_axis += 1
		retrospect_direction()
	elif (event.is_action_released("north")):
		y_axis += 1
		retrospect_direction()
	elif (event.is_action_released("east")):
		x_axis -= 1
		retrospect_direction()
	elif (event.is_action_released("health_add")):
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
	elif (event.is_action_released("zoom")):
		zooming = false;
	elif (event.is_action_released("pickup")):
		pick_up();

func pick_up() -> void:
	var arr = drop_range.get_overlapping_areas();
	print("trying pick up");
	for i in range(arr.size()):
		
		print(arr[i].texture_path);
		inventory.add_drop(arr[i]);



