extends StaticBody2D

func spawn_npc(npc_no, x, y):
    var NPC = preload("res://NPCs/NPC1/NPC1.tscn").instance()
    add_child(NPC)
    
    NPC.position = Vector2(x,y)

func _ready():
    spawn_npc(2, 175, 200)
