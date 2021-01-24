extends StaticBody2D

var NPC1: PackedScene = preload("res://NPCs/NPC1/NPC1.tscn")
var NPC2: PackedScene  = preload("res://NPCs/NPC2/NPC2.tscn")

func spawn_npc(NPCObject: PackedScene, spawnPosition: Vector2, infected: bool):
    var NPC: KinematicBody2D = NPCObject.instance()
    add_child(NPC)
    
    NPC.position = spawnPosition
    NPC.get_node("Stats").isInfected = infected

func _ready():
    spawn_npc(NPC1, Vector2(175, 200), true)
    spawn_npc(NPC2, Vector2(175, 400), false)
