class_name Jump extends Air


func _enter():
	get_input_direction()
	jump()
	
	
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
	
	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall")


func jump():
	var can_jump: bool = false
	if godot_essentials_platformer_movement.can_wall_jump():
		godot_essentials_platformer_movement.wall_jump(horizontal_direction)
		can_jump = true
		
	elif godot_essentials_platformer_movement.can_jump():
			godot_essentials_platformer_movement.jump()
			can_jump = true

	if animated_sprite and can_jump:
		animated_sprite.stop()
		animated_sprite.play("jump")

#func _on_animation_finished():
#	state_finished.emit("Fall")
