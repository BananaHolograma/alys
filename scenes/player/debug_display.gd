class_name DebugDisplay extends Control

@onready var godot_essentials_finite_state_machine: GodotEssentialsFiniteStateMachine = $"../GodotEssentialsFiniteStateMachine"
@onready var godot_essentials_platformer_movement_component: GodotEssentialsPlatformerMovementComponent = $"../GodotEssentialsPlatformerMovementComponent"

@onready var current_state_label: Label = $CurrentState
@onready var jump_height_label: Label = %JumpHeight
@onready var jump_velocity_label: Label = %JumpVelocity
@onready var jump_gravity_label: Label = %JumpGravity
@onready var fall_gravity_label: Label = %FallGravity
@onready var max_speed_label: Label = %"Max speed"
@onready var maximun_fall_velocity_label: Label = %"Maximun fall velocity"
@onready var actual_velocity_label: Label = %"Actual velocity"
@onready var acceleration_label: Label = %Acceleration
@onready var friction_label: Label = %Friction
@onready var dash_queue_label: Label = %DashQueue
@onready var jump_queue_label: Label = %JumpQueue
@onready var gravity_enabled_label: Label = %GravityEnabled
@onready var inverted_gravity_label: Label = %InvertedGravity
@onready var is_wall_climbing_label: Label = %IsWallClimbing
@onready var is_wall_sliding_label: Label = %IsWallSliding
@onready var is_dashing_label: Label = %IsDashing


func _ready():
	godot_essentials_finite_state_machine.state_changed.connect(on_state_changed)
	current_state_label.text = godot_essentials_finite_state_machine.current_state.name
	
	godot_essentials_platformer_movement_component.jumped.connect(on_jumped)
	godot_essentials_platformer_movement_component.jumps_restarted.connect(on_jumps_restarted)
	godot_essentials_platformer_movement_component.dash_restarted.connect(on_dash_restarted)
	
	display_jump_parameters()
	display_velocity_parameters()
	display_queues()

func _physics_process(delta):
	display_velocity_parameters()
	display_active_statuses()


func on_state_changed(_previous_state, new_state):
	current_state_label.text = new_state.name



func display_jump_parameters():
	jump_height_label.text = "Jump height: " + str(round(godot_essentials_platformer_movement_component.jump_height))
	jump_velocity_label.text = "Jump velocity: " + str(round(godot_essentials_platformer_movement_component.jump_velocity))
	jump_gravity_label.text = "Jump gravity: " + str(round(godot_essentials_platformer_movement_component.jump_gravity))
	fall_gravity_label.text = "Fall gravity: " + str(round(godot_essentials_platformer_movement_component.fall_gravity))


func display_velocity_parameters():
	var velocity: Vector2 = godot_essentials_platformer_movement_component.velocity
	max_speed_label.text = "Max speed: " + str(godot_essentials_platformer_movement_component.MAX_SPEED)
	acceleration_label.text = "Acceleration: " + str(godot_essentials_platformer_movement_component.ACCELERATION)
	friction_label.text = "Friction " + str(godot_essentials_platformer_movement_component.FRICTION)
	maximun_fall_velocity_label.text = "MAX fall velocity: " + str(godot_essentials_platformer_movement_component.MAXIMUM_FALL_VELOCITY)
	actual_velocity_label.text = "Velocity: " + str(Vector2(round(velocity.x), round(velocity.y)))


func display_queues():
	dash_queue_label.text = "Dash queue: " + str(godot_essentials_platformer_movement_component.dash_queue)		
	jump_queue_label.text = "Jump queue: " + str(godot_essentials_platformer_movement_component.jump_queue)		
	
	
	
func display_active_statuses():
	gravity_enabled_label.text = "Gravity enabled: " + str(godot_essentials_platformer_movement_component.gravity_enabled)
	inverted_gravity_label.text = "Inverted gravity: " + str(godot_essentials_platformer_movement_component.is_inverted_gravity)
	is_wall_climbing_label.text = "Wall climbing: " + str(godot_essentials_platformer_movement_component.is_wall_climbing)
	is_wall_sliding_label.text = "Wall sliding: " + str(godot_essentials_platformer_movement_component.is_wall_sliding)
	is_dashing_label.text = "Dashing: " + str(godot_essentials_platformer_movement_component.is_dashing)
	
	
func on_jumped(position: Vector2):
	display_jump_parameters()
	display_queues()
	

func on_dashed():
	display_queues()


func on_jumps_restarted():
	display_queues()
		
		
func on_dash_restarted():
	display_queues()