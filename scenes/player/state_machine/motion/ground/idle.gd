class_name Idle extends Ground



func _enter():
	if animated_sprite:
		animated_sprite.play("idle")
	
	godot_essentials_platformer_movement.reset_jump_queue()
	
	if not previous_states.is_empty() and previous_states.back() is Air:
		godot_essentials_platformer_movement.decelerate(0.0, true)
		
		
func physics_update(delta):
	super.physics_update(delta)
	
	godot_essentials_platformer_movement.move()
	
	if not horizontal_direction.is_zero_approx() and owner.is_on_floor():
		state_finished.emit("Run", {})
		return
	
	if Input.is_action_just_pressed("jump"):
		state_finished.emit("Jump", {})
		return
		
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return

	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall", {})
