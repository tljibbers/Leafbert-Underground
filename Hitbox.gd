extends Area2D


func _on_Hitbox_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
