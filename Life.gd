extends Node


func _ready():
	Lifecounter.lives = 3
	
func _physics_process(delta):
	
	if Lifecounter.lives == 2:
		$Sprite3/AnimationPlayer.animation = "loss"
	elif Lifecounter.lives == 1:
		$Sprite2/AnimationPlayer.animation = "loss"
	else:
		get_tree().reload_current_scene()


