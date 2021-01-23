extends KinematicBody2D

var speed: int = 200
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
		
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
		
	move_and_slide(velocity, Vector2.UP)
