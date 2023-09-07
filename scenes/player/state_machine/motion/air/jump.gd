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
		state_finished.emit("Dash", {})
		return
		
	if Input.is_action_pressed("climb") and godot_essentials_platformer_movement.can_wall_climb():
		state_finished.emit("WallClimb", {})
		return
		
	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall", {})


func jump() -> void:
	var can_jump: bool = false
	
	if  not owner.is_on_floor() and godot_essentials_platformer_movement.can_wall_jump():
		godot_essentials_platformer_movement.wall_jump(horizontal_direction)
		godot_essentials_platformer_movement.velocity.y += 15
		can_jump = true
		
	elif godot_essentials_platformer_movement.can_jump():
			godot_essentials_platformer_movement.jump()
			can_jump = true


	if animated_sprite and can_jump:
		animated_sprite.stop()
		animated_sprite.play("jump")
		var tween = create_tween()
		tween.tween_property(animated_sprite, "scale:x", 1.0, 0.4).from(0.85).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)


func on_jumped(position: Vector2) -> void:
	display_jump_effects(position)


func display_jump_effects(position: Vector2) -> void:
	if jump_dust_effect_scene:
		var jump_dust_effect = jump_dust_effect_scene.instantiate()
		
		if owner.velocity.x == 0:
			jump_dust_effect.current_animation = ["air_jump_smoke", "air_jump_smoke_2"].pick_random()
		else:
			if godot_essentials_platformer_movement.jump_queue.size() == 1:
				jump_dust_effect.current_animation =  "smoke_trail"
			else:
				jump_dust_effect.current_animation =  ["air_jump_smoke", "air_jump_smoke_2"].pick_random()
			
		jump_dust_effect.look_direction = horizontal_direction	
		get_tree().root.add_child(jump_dust_effect)
		jump_dust_effect.position = position

func display_wall_jump_effects(position: Vector2):
	pass
