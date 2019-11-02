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

export(Direction) var direction  = Direction.South; 
export var speed = 30.0;

var audio;
var animator;
var walking;
var x_axis = 0;
var y_axis = 0;
var velocity = Vector2.ZERO
var audio_position;

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("AudioStreamPlayer2D");
	animator = get_node("AnimationPlayer");
	audio_position = 0.0;
	walking = false;
	face_direction(direction);

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y = y_axis;
	velocity.x = x_axis;
	velocity *= speed;
	
	move_and_slide(velocity);
	if (y_axis == 0 and x_axis == 0):
		animate(Animation.Idle);
		if (audio.playing):
			audio_position = audio.get_playback_position()
			audio.stop()
	else:
		animate(Animation.Walking);
		if (not audio.playing):
			audio.play(audio_position)

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

	if (event.is_action_released("south")):
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
