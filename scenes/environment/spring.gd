extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var jump_boost_multiplier: float = 1.3
@export var horizontal_boost: float = 90
@export var direction: Vector2 = Vector2.ZERO

func _on_area_2d_body_entered(body):
	if body is Alys:
		animated_sprite_2d.play("bounce")
		body.godot_essentials_finite_state_machine.current_state.state_finished.emit(
		"Bounce",{"jump_boost_multiplier": jump_boost_multiplier, "horizontal_boost": horizontal_boost, "direction": direction}
		)
			
