class_name Alys extends CharacterBody2D

@onready var godot_essentials_platformer_movement_component: GodotEssentialsPlatformerMovementComponent = $GodotEssentialsPlatformerMovementComponent
@onready var godot_essentials_finite_state_machine: GodotEssentialsFiniteStateMachine = $GodotEssentialsFiniteStateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effects: Node2D = $Effects


var is_left_direction: bool = false

func _ready():
	disable_effects()
	animation_player.animation_finished.connect(on_animation_player_finished) 

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


func _on_hurtbox_area_entered(area):
	animation_player.play("death")
	godot_essentials_finite_state_machine.lock_state_machine()
	

func on_animation_player_finished(name: String):
	if name == "death":
		global_position = get_tree().get_first_node_in_group("respawn").global_position
		animated_sprite_2d.modulate.a = 1.0
		godot_essentials_finite_state_machine.unlock_state_machine()
