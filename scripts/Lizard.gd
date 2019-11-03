extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum State {
	Idle, Awake, Walking, Chasing, Dead
}

var state = State.Idle
export var speed = 50.0

var timer;
var timer_set = false;
const IdleTime = 2;
const AwakeTime = 0.4;
const WalkingTime = 5;
var animator;
var velocity = Vector2();
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	animator = get_node("AnimationPlayer");
	set_timer(IdleTime);

func hit():
	queue_free()

# can be implemented to use random times later
func set_timer(time):
	timer = time;

func timer_up():
	if (state == State.Idle):
		state = State.Awake;
		animator.play("walk");
		set_timer(AwakeTime);
	elif (state == State.Awake):
		state = State.Walking;
		set_timer(WalkingTime);
		walk();
	elif (state == State.Walking):
		state = State.Idle;
		animator.play("idle");
		set_timer(IdleTime);
		velocity = Vector2.ZERO

func walk():
	var direction = rng.randi_range(0, 3)
	rotation = direction * PI / 2
	velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		walk()
		if collision.collider.has_method("hit"):
			collision.collider.hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (timer > 0):
		timer -= delta;
	else:
		timer_up()
