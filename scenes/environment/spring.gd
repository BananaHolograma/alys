extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_body_entered(body):
	if body is Alys:
		animated_sprite_2d.play("bounce")
		print("JUMP!!")
