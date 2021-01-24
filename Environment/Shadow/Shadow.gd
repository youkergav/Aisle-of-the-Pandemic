extends Area2D

var offset: Vector2 = Vector2(-10, -10)
var upscale: float = 1.15
var defaultColor: Color = Color(0, 0, 0, .5)
onready var Parent: KinematicBody2D = get_parent()

func gen_sprite():
    var ParentSprite: Sprite = Parent.get_node("Sprite")
    
    $Sprite.hframes = ParentSprite.hframes
    $Sprite.vframes = ParentSprite.vframes
    $Sprite.texture = ParentSprite.texture
    $Sprite.position = offset
    $Sprite.modulate = defaultColor
    $Sprite.scale = Vector2(upscale, upscale)
    
func gen_hitbox():
    var ParentCollisionBox: CollisionShape2D = Parent.get_node("CollisionBox")
    
    $Hitbox.shape.height = ParentCollisionBox.get_shape().height * upscale
    $Hitbox.shape.radius = ParentCollisionBox.get_shape().radius * upscale
    $Hitbox.position = $Sprite.position
    
func update_sprite():
    var ParentSprite: Sprite = Parent.get_node("Sprite")
    
    $Sprite.frame = ParentSprite.frame
    
func _ready():
    gen_sprite()
    gen_hitbox()

func _physics_process(delta):
    update_sprite()

func _on_area_entered(area):
    var StrangerStats: Node = area.get_parent().get_node("Stats")
        
    if StrangerStats.isInfected:
        get_parent().get_node("Stats").isInfected = true
        
    print(StrangerStats.isInfected)
    $Sprite.modulate = Color(1, 0, 0, .5)

func _on_area_exited(area):
    $Sprite.modulate = defaultColor
