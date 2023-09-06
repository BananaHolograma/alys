class_name Wall extends GodotEssentialsState

var animation_player: AnimationPlayer
var animated_sprite: AnimatedSprite2D
var godot_essentials_platformer_movement: GodotEssentialsPlatformerMovementComponent

var horizontal_direction: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2.ZERO


func _ready():
	animation_player = owner.get_node("AnimationPlayer") as AnimationPlayer
	animated_sprite = owner.get_node("AnimatedSprite2D") as AnimatedSprite2D
	godot_essentials_platformer_movement = owner.get_node("GodotEssentialsPlatformerMovementComponent") as GodotEssentialsPlatformerMovementComponent


func get_input_direction():
	horizontal_direction = Helpers.translate_x_axis_to_vector(Input.get_axis("ui_left", "ui_right"))
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
