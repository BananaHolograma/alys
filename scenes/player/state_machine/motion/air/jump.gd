class_name Jump extends Air

var jump_dust_effect_scene: PackedScene = preload("res://scenes/effects/jump_dust.tscn")

func _enter():
	get_input_direction()
	jump()
	
func _ready():
	super._ready()
	godot_essentials_platformer_movement.jumped.connect(on_jumped)
	
	
func physics_update(delta):
	super.physics_update(delta)
	
	if not horizontal_direction.is_zero_approx():
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)\
			.apply_air_friction_vertical()
		
	if Input.is_action_just_pressed("jump"):
		jump()

	if Input.is_action_just_released("jump"):
		godot_essentials_platformer_movement.shorten_jump()
	
	godot_essentials_platformer_movement.move()
	
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash")
		return
		
	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall")


func jump() -> void:
	var can_jump: bool = false
	
	if  not owner.is_on_floor() and godot_essentials_platformer_movement.can_wall_jump():
		godot_essentials_platformer_movement.wall_jump(horizontal_direction)
		can_jump = true
		
	elif godot_essentials_platformer_movement.can_jump():
			godot_essentials_platformer_movement.jump()
			can_jump = true

	if animated_sprite and can_jump:
		animated_sprite.stop()
		animated_sprite.play("jump")


func on_jumped(position: Vector2) -> void:
	if godot_essentials_platformer_movement.jump_queue.size() == 1 and owner.is_on_floor():
		display_jump_dust(position)


func display_jump_dust(position: Vector2) -> void:
	if jump_dust_effect_scene:
		var jump_dust_effect = jump_dust_effect_scene.instantiate()
		jump_dust_effect.current_animation = "dust" if owner.velocity.x == 0 else "smoke_trail"
		jump_dust_effect.look_direction = horizontal_direction	
		get_tree().root.add_child(jump_dust_effect)
		jump_dust_effect.position = position

