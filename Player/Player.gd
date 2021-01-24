extends KinematicBody2D

var speed: int = 200
var velocity: Vector2 = Vector2.ZERO
onready var animation = $AnimationPlayer

# FIXME: update for all grocery item nodes
# FIXME: also be sure to update the GUI shopping list labels
# FIXME: spelling counts!
var todo_list = [
    "rice_ball",
    "milk",
    "bread",
    "pie",
    "cupcake",
    "popsicle",
    "popcorn",
    "soup"
]
var time_left = 50

func can_i_pick_up(item_node):

    # Get the position of the item_node on the map
    var item_position: Vector2 = item_node.position

    # Get distance between item and player on x axis
    var y_distance = abs(abs(position.y) - abs(item_position.y))
    # Get distance between item and player on y axis
    var x_distance = abs(abs(position.x) - abs(item_position.x))

    # If the player is within 35 units on both axes, pickup the item
    if y_distance < 40 and x_distance < 40:
        return true
    else:
        return false

func grab_item(todo_item):

    # Remove the item's node from the map
    get_parent().get_node(todo_item).queue_free()
    # Update the shopping list UI to show this item checked off
    get_node("Camera2D/GUI").get_node("rows").get_node(todo_item).get_node("status").text = "- [X] "


func try_to_pickup(groceries_to_get):

    var groceries_left_to_get = []

    for grocery_item in groceries_to_get:

        # var item_node = get_parent().get_node("rice_ball")
        print(get_parent())
        var item_node = get_parent().get_node(grocery_item)

        # If the player is close enough to pick up item
        print(grocery_item)
        if can_i_pick_up(item_node) == true:
            # Pick the item up and update the map and GUI
            grab_item(grocery_item)
        else:
            # Add the item to a new todo list to overwrite top-level todo
            groceries_left_to_get.append(grocery_item)

    # Return the new list of items remaining to grab
    return groceries_left_to_get

func game_over():

    var infection_status: bool = get_node("Stats").isInfected
    var winning_condition: bool = not infection_status

    print("Is infected? " + str(infection_status))
    print("Did you win? " + str(winning_condition))

    # Send the player to the right game over screen based on winning condition
    if winning_condition == true:
        get_tree().change_scene("res://GameOver_good.tscn")
    if winning_condition == false:
        get_tree().change_scene("res://GameOver_bad.tscn")

func checkout():

    # All possible cash register nodes
    var checkout_registers = ["register1", "register2", "register3", "register4"]

    # Check all register nodes to see if one is close enough
    for register in checkout_registers:

        # var item_node = get_parent().get_node("rice_ball")
        var register_node = get_parent().get_node(register)

        # If the player is close enough to pick up item
        if can_i_pick_up(register_node) == true:

            # End the game
            game_over()

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
    
    print(position)

    # If the player tried to interact with something
    if Input.is_action_pressed("interact"):

        # If there is nothing left, try to checkout
        if todo_list == []:
            checkout()
        # If they still have groceries to get, try to pick them up
        else:
            # Try to pick up everything on the todo list
            # Update the todo list to only keep what we didn't pick up
            var items_left = try_to_pickup(todo_list)
            # Update the items_left to be what was left over after last grab
            todo_list = items_left
