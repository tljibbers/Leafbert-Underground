extends Node2D


func _on_spike_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
		
