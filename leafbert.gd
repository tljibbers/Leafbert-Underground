extends KinematicBody2D
class_name Player

signal life_changed(player_hearts)

export(int) var JUMP_HEIGHT = -130
export(int) var JUMP_RELEASE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4
export(int) var BOUNCE_VELOCITY = -1000
export(int) var KNOCKBACK = 1000
export(int) var KNOCKUP = 500
export(int) var DOUBLE_JUMPS_COUNT = 1 
var health = 3
var coins = 0



var velocity = Vector2.ZERO # Means that Velocity will be zero
var double_jump = 1
onready var bounce_raycasts = $BounceRaycasts


func _physics_process(delta): # called every single physics frame of the game. Delta is 1/60th of a second.
	apply_gravity() # Applies a gravity to our character in the y direction.
	var input = Vector2.ZERO # A vector that contains the input for the characters movement.
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#The line above gets a number between -1 and 1
	if input.x == 0:
		apply_friction()
		$AnimatedSprite.animation = "idle" #same as getnode
	else:
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "running"
		if input.x > 0:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
	
	if is_on_floor():
		double_jump = DOUBLE_JUMPS_COUNT
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_HEIGHT #If the up arrow key is pressed, then the player jumps up at -200m/s
			$AnimatedSprite.animation = "jump"
			$Jump.play()
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE:
			velocity.y = JUMP_RELEASE
			
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			velocity.y = JUMP_HEIGHT
			double_jump -= 1
			
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
			
	_check_bounce(delta)
	#Just having velocity.y won't make the character move. We will need a special function for the character to be able to move.
	velocity = move_and_slide(velocity, Vector2.UP) #This function moves our character and detects collisions and handle them.
	#Another thing move_and_slide does is return Vector2, which means that once it is done
	#computing, it spits back out something, and that thing is how much velocity was left over after the collision.
	#whatever is left over after our collision, that becomes the new velocity, which is why velocity = move_and_slide
	#If you didn't put velocity = move_and_slide, then the velocity doesn't reset, and would become a very large number, leading to problems.
	
		
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
	
func _check_bounce(delta):
	if velocity.y > 0:
		for raycast in bounce_raycasts.get_children():
			raycast.cast_to = Vector2.DOWN * velocity * delta + Vector2.DOWN
			raycast.force_raycast_update()
			if raycast.is_colliding() && raycast.get_collision_normal() == Vector2.UP:
				velocity.y = (raycast.get_collision_point() - raycast.global_position - Vector2.DOWN).y / delta
				raycast.get_collider().entity.call_deferred("be_bounced_upon", self)
				break

func bounce(bounce_velocity = BOUNCE_VELOCITY):
	velocity.y = bounce_velocity

func hurt():
	Global.lose_life()
	$Hit.play()
	velocity.y = JUMP_HEIGHT * 1
	
	health -= 1
	print(health)
	if health == 0:
		get_tree().change_scene("res://GameOver.tscn")

func _on_fallzone_body_entered(body):
	Global.lose_life()
	if Global.lives >= 1:
		get_tree().reload_current_scene()
		
