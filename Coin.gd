extends Area2D

signal coin_collected

func _on_Coin_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("bounce")
		$Collect.play()
		emit_signal("coin_collected")
		set_collision_mask_bit(1,false)
		

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
