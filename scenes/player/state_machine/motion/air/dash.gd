class_name Dash extends Air

@export var dash_effect_times: int = 3

var dash_effect_queue: Array[Vector2] = []


func _ready():
	super._ready()
	godot_essentials_platformer_movement.dashed.connect(on_dashed)
	godot_essentials_platformer_movement.finished_dash.connect(on_finished_dash)

func _enter():
	get_input_direction()
	dash()


func _exit():
	godot_essentials_platformer_movement.gravity_enabled = true
	dash_effect_queue.clear()

	
func physics_update(delta):
	super.physics_update(delta)
	
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		dash()
			
	godot_essentials_platformer_movement.apply_air_friction_horizontal()\
			.apply_air_friction_vertical()\
			.move()
			
	if godot_essentials_platformer_movement.is_dashing:
		update_animations()
	else:
		if owner.is_on_floor():
			if horizontal_direction.is_zero_approx():
				state_finished.emit("Idle")
				return
			else:
				state_finished.emit("Run")
				return
		if godot_essentials_platformer_movement.is_falling():
			state_finished.emit("Fall")
			return

	if Input.is_action_just_pressed("jump") and (godot_essentials_platformer_movement.can_jump() or godot_essentials_platformer_movement.can_wall_jump()):
		state_finished.emit("Jump")
		return


func dash():
	godot_essentials_platformer_movement.decelerate(0.0, true).dash(input_direction)
	
	
func update_animations():
	if animated_sprite:
		if previous_states.back() is Ground:
			animated_sprite.play("dash_ground")
		if previous_states.back() is Air:
			animated_sprite.play("dash_air")
		
		if animated_sprite.is_playing():
#			var current_position = animated_sprite.sprite_frames.

#			if current_position > 0.1 and current_position < 0.12 or \
#			 	current_position > 0.25 and current_position < 0.27 or \
#				current_position >= 0.4 and current_position < 0.42:
#
				dash_effect()
		
		
func dash_effect():
	if animated_sprite:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)

		get_tree().root.add_child(sprite)
		
		sprite.modulate = Color.WHITE
		sprite.global_position = animated_sprite.global_position
		sprite.scale = animated_sprite.scale
		sprite.flip_h = animated_sprite.flip_h
		sprite.flip_v = animated_sprite.flip_v

		var tween: Tween = create_tween()
		
		tween.tween_property(sprite, "modulate:a", 0.0, 0.7).set_trans(tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_callback(sprite.queue_free)


func on_dashed(_position: Vector2):
	godot_essentials_platformer_movement.gravity_enabled = false
	
	
func on_finished_dash(_initial_position: Vector2, _final_position: Vector2):
	godot_essentials_platformer_movement.gravity_enabled = true