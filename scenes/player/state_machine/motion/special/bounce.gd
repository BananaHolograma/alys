class_name Bounce extends Special


func _enter():
	get_input_direction()
	var direction = input_direction if params["direction"].is_zero_approx() else params["direction"]
	
	godot_essentials_platformer_movement.jump(godot_essentials_platformer_movement.jump_height, true)
	godot_essentials_platformer_movement.velocity.y *= params["jump_boost_multiplier"]
	godot_essentials_platformer_movement.velocity.x = sign(direction.x) * params["horizontal_boost"]

	animated_sprite.play("jump")


func _exit():
	animated_sprite.stop()
	
	
func physics_update(delta):
	super.physics_update(delta)
	
	if not horizontal_direction.is_zero_approx():
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)
	
	godot_essentials_platformer_movement.apply_gravity().move()
	
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return
		
	if Input.is_action_pressed("climb") and godot_essentials_platformer_movement.can_wall_climb():
		state_finished.emit("WallClimb", {})
		return
		
	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Neutral", {})
