extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var Ledge: = $Ledge
onready var Ledge2: = $Ledge2
onready var sprite: = $AnimatedSprite
onready var timer = $Timer

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_ledge = not Ledge.is_colliding()
	var found_ledge2 = not Ledge2.is_colliding()
	
	if found_wall or found_ledge or found_ledge2:
		direction *= -1
	
	sprite.animation = "move"	
	if direction.x > 0:
		sprite.flip_h = false
	if direction.x < 0:
		sprite.flip_h = true
	
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
	
func be_bounced_upon(bouncer):
	if bouncer.has_method("bounce"):
		bouncer.bounce()
		sprite.animation = "death"
		$Good.play()
		queue_free()
		

