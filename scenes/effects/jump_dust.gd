class_name JumpDustEffect extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dust_smoke_trail: AnimatedSprite2D = $DustSmokeTrail
@onready var second_jump_smoke: AnimatedSprite2D = $SecondJumpSmoke

@onready var animation_list: PackedStringArray = animation_player.get_animation_list()
var current_animation: String = "dust"
var look_direction: Vector2 = Vector2.LEFT

func _ready():
	if current_animation == "smoke_trail":
			if look_direction == Vector2.LEFT:		
				dust_smoke_trail.flip_h = true
				dust_smoke_trail.position.x *= -1
				
	if current_animation in animation_list:
		animation_player.play(current_animation)
	else:
		push_error("The animation {name} does not exists on the animation player list".format({"name": current_animation}))

