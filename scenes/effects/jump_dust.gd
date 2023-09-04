extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dust_smoke_trail: AnimatedSprite2D = $DustSmokeTrail

var current_animation: String = "dust"
var look_direction: Vector2 = Vector2.LEFT

func _ready():
	if current_animation == "smoke_trail":
			if look_direction == Vector2.LEFT:		
				dust_smoke_trail.flip_h = true
				dust_smoke_trail.position.x *= -1
	
	animation_player.play(current_animation)
	

