extends KinematicBody2D

var speed: int = 200
var velocity: Vector2 = Vector2.ZERO

var last_position: Vector2 = position
var possible_directions: Array = ["left", "right", "up", "down"]
var last_direction: String = ""
var current_direction: String = ""
var slow_multiple: int = 3
# % chance that an npc will continue in current direction
var momentum_bias: int = 95

onready var animation = $AnimationPlayer

# Want characters to keep moving forward as long as they don't collide
# Check if the character collided by seeing if they moved since the last delta
# Log position during each _physic_process() call
# At the end of each _physics_process() call save the new position and compare to old
# If positions are identical, then move in a different cardinal direction
# RNG the first cardinal direction
# From then on, 90% chance of continuing in current direction, 10% chance of re-roll
# Force direction re-roll on collision

func should_i_pause_movement(slow_multiple):

    # Roll an RNG between 1 and 100
    var rng_value: int = randi()%slow_multiple+1

    if rng_value == 1:
        return false
    elif rng_value > 1:
        return true


func pick_direction(possible_directions):

    # Get the total number of elements in list of possible directions
    var number_of_possible_directions = possible_directions.size()

    # Roll an RNG between our possible number of directions
    var rng_value: int = randi()%number_of_possible_directions+0
    # Index the list of possible directions for our RNG to get new direction
    current_direction = possible_directions[rng_value]

    return current_direction

func roll_for_direction(last_position, last_direction):

    var current_position: Vector2 = position
    var just_had_collision: bool = current_position == last_position

    # Roll an RNG between 1 and 100
    var rng_value: int = randi()%100+1

    # If current direction is not "", and position has changed, normal roll
    if last_direction != "" and just_had_collision == false:
        if rng_value > momentum_bias:
            current_direction = pick_direction(possible_directions)
        elif rng_value <= momentum_bias:
            current_direction = last_direction

    # Else if we don't have a direction or just had a collision, pick new
    elif last_direction == "" or just_had_collision == true:
        current_direction = pick_direction(possible_directions)

    # # Debug
    # print("collision detection: " + str(just_had_collision))
    # print("rng output: " + str(rng_value))
    # print("last position: " + str(last_position))
    # print("last_direction: " + last_direction)
    # print("current_direction: " + current_direction)
    # print("--------------")

    return current_direction

func gen_shadow():
    $Shadow/Sprite.hframes = $Sprite.hframes
    $Shadow/Sprite.vframes = $Sprite.vframes
    $Shadow/Sprite.texture = $Sprite.texture
    $Shadow/Sprite.position = Vector2 (-10, -10)
    $Shadow/Sprite.modulate = Color(0, 0, 0, .5)
    $Shadow/Sprite.scale = Vector2(1.15, 1.15)

func _physics_process(delta):

    # Only proceed with physics once in a while
    if should_i_pause_movement(slow_multiple) == false:

        # Wut do?
        velocity.x = 0
        velocity.y = 0

        current_direction = roll_for_direction(last_position, last_direction)

        # Log the last position and direction before trying to move
        last_direction = current_direction
        last_position = position

        if current_direction == "left":
            animation.play("WalkLeft")
            velocity.x -= speed

        if current_direction == "right":
            animation.play("WalkRight")
            velocity.x += speed

        if current_direction == "up":
            animation.play("WalkUp")
            velocity.y -= speed

        if current_direction == "down":
            animation.play("WalkDown")
            velocity.y += speed

        move_and_slide(velocity, Vector2.UP)
        $Shadow/Sprite.frame = $Sprite.frame

        # print("NPC Position: " + str(last_position))
        
func _ready():
    gen_shadow()


func _on_Stats_infect():
    queue_free()
