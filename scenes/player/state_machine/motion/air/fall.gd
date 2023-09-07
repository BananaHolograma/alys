class_name Fall extends Air


func _enter():
	if animated_sprite:
		animated_sprite.play("fall")
	
	
func physics_update(delta):
	super.physics_update(delta)
	
	if not horizontal_direction.is_zero_approx():
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction)
	
	godot_essentials_platformer_movement.move()
	
	if owner.is_on_floor():
		if horizontal_direction.is_zero_approx():
			state_finished.emit("Idle", {})
			return
		else:
			state_finished.emit("Run", {})
			return
	
	if Input.is_action_just_pressed("jump")\
		and (godot_essentials_platformer_movement.can_jump() or godot_essentials_platformer_movement.can_wall_jump()):
		state_finished.emit("Jump", {})
		return
		
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return
		
	if Input.is_action_pressed("climb") and godot_essentials_platformer_movement.can_wall_climb():
		state_finished.emit("WallClimb", {})
		return
