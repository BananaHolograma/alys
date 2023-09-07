class_name Run extends Ground

@onready var running_dust: CPUParticles2D = $"../../../Effects/RunningDust"

func _enter():
	if animated_sprite:
		animated_sprite.play("run")
	
	if running_dust:
		running_dust.emitting = true
		
	godot_essentials_platformer_movement.reset_jump_queue()

	if previous_states.back() is Air:
		godot_essentials_platformer_movement.velocity.y = 0
		
		
func _exit():
	running_dust.emitting = false


func physics_update(delta):
	super.physics_update(delta)
	
	if horizontal_direction.is_zero_approx():
		if godot_essentials_platformer_movement.velocity.x == 0:
			state_finished.emit("Idle", {})
			return
		else:
			godot_essentials_platformer_movement.decelerate_horizontally(delta)
	else:
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)
		emit_dust_particles(horizontal_direction)
	
	godot_essentials_platformer_movement.move()
	
	if Input.is_action_just_pressed("jump"):
		state_finished.emit("Jump", {})
		return
		
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return
		
	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall", {})


func emit_dust_particles(horizontal_direction: Vector2):
	match(horizontal_direction):
		Vector2.RIGHT:
			running_dust.gravity = Vector2(-running_dust.gravity.x, running_dust.gravity.y)
		Vector2.LEFT:
			running_dust.gravity =  Vector2(abs(running_dust.gravity.x), running_dust.gravity.y)
	
	running_dust.direction = horizontal_direction
