extends KinematicBody2D

var speed: int = 200
var velocity: Vector2 = Vector2.ZERO
onready var animation = $AnimationPlayer

func walk():
    velocity.x = 0
    velocity.y = 0
    
    if Input.is_action_pressed("move_left"):
        animation.play("WalkLeft")
        velocity.x -= speed
        
    if Input.is_action_pressed("move_right"):
        animation.play("WalkRight")
        velocity.x += speed
        
    if Input.is_action_pressed("move_up"): 
        animation.play("WalkUp")
        velocity.y -= speed
        
    if Input.is_action_pressed("move_down"): 
        animation.play("WalkDown")
        velocity.y += speed
    
    move_and_slide(velocity, Vector2.UP)
    
func idle():
    if Input.is_action_just_released("move_left"):
        animation.play("IdleLeft")
        
    if Input.is_action_just_released("move_right"):
        animation.play("IdleRight")
        
    if Input.is_action_just_released("move_up"): 
        animation.play("IdleUp")
        
    if Input.is_action_just_released("move_down"): 
        animation.play("IdleDown")
        
func spin():
    if Input.is_action_just_released("spin"): 
        animation.play("Spin")
    
func _physics_process(delta):
    walk()
    idle()
    spin()
