extends Area2D

var offset: Vector2 = Vector2(-10, -10)
var upscale: float = 1.15
var defaultColor: Color = Color(0, 0, 0, .5)
onready var ParentSprite: Sprite = get_parent().get_node("Sprite")
onready var ParentCollisionBox: CollisionShape2D = get_parent().get_node("CollisionBox")

func gen_sprite():    
    $Sprite.hframes = ParentSprite.hframes
    $Sprite.vframes = ParentSprite.vframes
    $Sprite.texture = ParentSprite.texture
    $Sprite.position = offset
    $Sprite.modulate = defaultColor
    $Sprite.scale = Vector2(upscale, upscale)
    
func gen_hitbox():
    var parentScale: Vector2 = ParentCollisionBox.get_transform().get_scale()
    
    $Hitbox.shape.height = ParentCollisionBox.get_shape().height * upscale
    $Hitbox.shape.radius = ParentCollisionBox.get_shape().radius * upscale
    $Hitbox.position = $Sprite.position
    
func update_sprite():
    $Sprite.frame = ParentSprite.frame
    
func _ready():
    gen_sprite()
    gen_hitbox()

func _physics_process(delta):
    update_sprite()

func _on_area_entered(area):
    print()
    $Sprite.modulate = Color(1, 0, 0, .5)

func _on_area_exited(area):
    $Sprite.modulate = defaultColor
