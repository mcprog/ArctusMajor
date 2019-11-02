extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 700
var velocity = Vector2()
var animator;


func start(pos, dir):
	rotation = (dir) * PI / 180
	position = pos
	velocity = Vector2(0, speed).rotated(rotation)
	animator = get_node("AnimationPlayer");

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO
		explode()
		if collision.collider.has_method("hit"):
			collision.collider.hit()

func explode():
	animator.play("explode")

# remove function when done testing
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "explode"):
		queue_free()
