extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)
	load_hearts()
	Global.hud = self

func load_hearts():
	$heartsFull.rect_size.x = Global.lives * 16
	$heartsEmpty.rect_size.x = (Global.max_lives - Global.lives) * 16
	$heartsEmpty.rect_position.x = $heartsFull.rect_position.x + $heartsFull.rect_size.x * $heartsFull.rect_scale.x

func _on_coin_collected():
	coins = coins + 1
	_ready()
	if coins == 17:
		get_tree().change_scene("res://Win.tscn")
