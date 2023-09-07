class_name Neutral extends Special

@export var neutral_state_time: float = 0.1
var neutral_state_timer: Timer


func _ready():
	super._ready()
	_create_neutral_state_timer()


func _enter():
	neutral_state_timer.start()

func _exit():
	neutral_state_timer.stop()

func physics_update(delta):
	super.physics_update(delta)
	
	if not horizontal_direction.is_zero_approx():
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)
	
	godot_essentials_platformer_movement.move()
	
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return
		
	if Input.is_action_pressed("climb") and not previous_states.back() is WallClimb and godot_essentials_platformer_movement.can_wall_climb():
		state_finished.emit("WallClimb", {})
		return
		


func _create_neutral_state_timer():
	if neutral_state_timer:
		return
		
	neutral_state_timer= Timer.new()
	neutral_state_timer.name = "NeutralStateTimer"
	neutral_state_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	neutral_state_timer.wait_time = neutral_state_time
	neutral_state_timer.one_shot = true
	neutral_state_timer.autostart = false
	
	add_child(neutral_state_timer)
	neutral_state_timer.timeout.connect(on_neutral_state_timer_timeout)


func on_neutral_state_timer_timeout():
	state_finished.emit("Fall", {})
