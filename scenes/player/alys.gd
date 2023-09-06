extends CharacterBody2D

@onready var godot_essentials_platformer_movement_component: GodotEssentialsPlatformerMovementComponent = $GodotEssentialsPlatformerMovementComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_left_direction: bool = false


func _process(delta):
	_update_sprite_flip()


func _update_sprite_flip():
	is_left_direction = godot_essentials_platformer_movement_component.last_faced_direction.x < 0
	
	if animated_sprite_2d.flip_h != is_left_direction:
		animated_sprite_2d.flip_h = is_left_direction
