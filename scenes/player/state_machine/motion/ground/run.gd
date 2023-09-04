class_name Run extends Ground


func _enter():
	if animated_sprite:
		animated_sprite.play("run")
	
	godot_essentials_platformer_movement.reset_jump_queue()

	if previous_states.back() is Air:
		godot_essentials_platformer_movement.decelerate(0.0, true)

func physics_update(delta):
	super.physics_update(delta)
	
	if horizontal_direction.is_zero_approx():
		if godot_essentials_platformer_movement.velocity.x == 0:
			state_finished.emit("Idle")
			return
		else:
			godot_essentials_platformer_movement.decelerate_horizontally(delta)
	else:
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)
	
	
	if Input.is_action_just_pressed("jump"):
		state_finished.emit("Jump")
		return
		
	godot_essentials_platformer_movement.move()
