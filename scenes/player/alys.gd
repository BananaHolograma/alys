class_name Alys extends CharacterBody2D

@onready var godot_essentials_platformer_movement_component: GodotEssentialsPlatformerMovementComponent = $GodotEssentialsPlatformerMovementComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var effects: Node2D = $Effects

var is_left_direction: bool = false

func _ready():
	disable_effects()


func _process(delta):
	_update_sprite_flip()


func _update_sprite_flip():
	is_left_direction = godot_essentials_platformer_movement_component.last_faced_direction.x < 0
	
	if animated_sprite_2d.flip_h != is_left_direction:
		animated_sprite_2d.flip_h = is_left_direction


func disable_effects():
	for effect in effects.get_children():
		if effect in [CPUParticles2D, GPUParticles2D]:
			effect.emitting = false
