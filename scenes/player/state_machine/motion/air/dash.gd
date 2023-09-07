class_name Dash extends Air

@export var dash_effect_times: int = 3
@onready var shake_camera_component_2d = $"../../../Camera2D/ShakeCameraComponent2D" as ShakeCameraComponent2D
@onready var dash_trail: CPUParticles2D = $"../../../Effects/DashTrail"


var dash_effect_queue: Array[Vector2] = []
var dash_animation_time: int = 0


func _ready():
	super._ready()
	godot_essentials_platformer_movement.dashed.connect(on_dashed)
	godot_essentials_platformer_movement.finished_dash.connect(on_finished_dash)


func _enter():
	get_input_direction()
	dash()
	dash_trail.emitting = true
	dash_trail.direction = input_direction

func _exit():
	godot_essentials_platformer_movement.gravity_enabled = true
	dash_effect_queue.clear()
	dash_trail.emitting = false


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
				state_finished.emit("Idle", {})
				return
			else:
				state_finished.emit("Run", {})
				return
		if godot_essentials_platformer_movement.is_falling():
			state_finished.emit("Fall", {})
			return

	if Input.is_action_just_pressed("jump") and (godot_essentials_platformer_movement.can_jump() or godot_essentials_platformer_movement.can_wall_jump()):
		state_finished.emit("Jump", {})
		return
		
			
	if Input.is_action_pressed("climb") and godot_essentials_platformer_movement.can_wall_climb():
		state_finished.emit("WallClimb", {})
		return
		
	if owner.is_on_wall():
		godot_essentials_platformer_movement.jump(godot_essentials_platformer_movement.jump_height / 3, true)
		state_finished.emit("Neutral", {})


func dash():
	godot_essentials_platformer_movement.decelerate(0.0, true).dash(input_direction)
	dash_animation_time = 0
	shake_camera_component_2d.shake(1.0)
	dash_trail.direction = input_direction
	
func update_animations():
	if animated_sprite:
		var animation_to_run = ""
		
		if previous_states.back() is Ground:
			animation_to_run = "dash_ground"
		if previous_states.back() is Air:
			animation_to_run = "dash_air"
		
		animated_sprite.play(animation_to_run)
		
		if animated_sprite.is_playing():
			dash_animation_time += 1
			if dash_animation_time in [3,9,15]:
				dash_effect()
			
		

func dash_effect():
	if animated_sprite:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)

		get_tree().root.add_child(sprite)
		
		sprite.global_position = animated_sprite.global_position
		sprite.scale = animated_sprite.scale
		sprite.flip_h = animated_sprite.flip_h
		sprite.flip_v = animated_sprite.flip_v
		sprite.modulate = Color(249.0, 58.0, 59.0, 0.75)
		var tween: Tween = create_tween()
		
		tween.tween_property(sprite, "modulate:a", 0.0, 0.7).set_trans(tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_callback(sprite.queue_free)


func on_dashed(_position: Vector2):
	godot_essentials_platformer_movement.gravity_enabled = false
	
	
func on_finished_dash(_initial_position: Vector2, _final_position: Vector2):
	godot_essentials_platformer_movement.gravity_enabled = true
	
	if not godot_essentials_platformer_movement.is_dashing and not owner.is_on_floor():
		state_finished.emit("Neutral", {})
	
