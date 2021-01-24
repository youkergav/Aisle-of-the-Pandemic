extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawn_npc(npc_no, x, y):

    var resource_path = "res://Characters/npc/npc" + str(npc_no) + ".tscn"
    var npc = load(resource_path).instance()
    add_child(npc)
    npc.position = Vector2(x,y)

# Called when the node enters the scene tree for the first time.
func _ready():

    spawn_npc(2, 175, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
