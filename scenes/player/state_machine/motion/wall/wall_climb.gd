class_name WallClimb extends Wall

@onready var ledge_climb_detector: RayCast2D = $"../../../LedgeClimbDetector"


func _ready():
	super._ready()
	godot_essentials_platformer_movement.knockback_received.connect(on_fatigue_knockback)


func _enter():
	godot_essentials_platformer_movement.decelerate(0.0, true).is_wall_climbing = true
	animated_sprite.play("climb")
	ledge_climb_detector.enabled = true
	
	
func _exit():
	ledge_climb_detector.enabled = false
	godot_essentials_platformer_movement.is_wall_climbing = false
	animated_sprite.stop()


func physics_update(delta):
	get_input_direction()
	
	if Input.is_action_pressed("climb"):
		godot_essentials_platformer_movement.wall_climb(input_direction).move()
		
		if input_direction in [Vector2.UP, Vector2.DOWN]:
			animated_sprite.play("climb")
		else:
			animated_sprite.stop()
		
		
		if not ledge_climb_detector.is_colliding():
			climb_on_ledge(delta)
			return
			
	
	if owner.is_on_floor():
		state_finished.emit("Idle", {})
		return
		
	if Input.is_action_just_pressed("jump") and godot_essentials_platformer_movement.can_wall_jump():
		state_finished.emit("Jump", {})
		return
		
	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return

	if Input.is_action_just_released("climb"):
		state_finished.emit("Fall", {})
		return


func climb_on_ledge(delta):
	godot_essentials_platformer_movement.decelerate_horizontally(delta).velocity.x =  sign(ledge_climb_detector.target_position.x) *  25
	godot_essentials_platformer_movement.move()
	state_finished.emit("Neutral", {})

func on_fatigue_knockback(_direction: Vector2, _power: float):
	state_finished.emit("Fall", {})


