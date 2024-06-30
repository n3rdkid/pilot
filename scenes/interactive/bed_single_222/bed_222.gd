extends Node2D
@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D

enum Status {vacant,occupied}
var current_state = Status.vacant

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self,"_on_interact")

func _on_interact():
	if(current_state == Status.vacant):
		current_state= Status.occupied
		interaction_area.action_name="wake up"
		# Collision was cause the player to go outside
		collision_shape_2d.disabled = true
		InteractionManager.animate_player_interaction("sleep")
		animated_sprite_2d.play("sleep_right")
		return
	if(current_state == Status.occupied):
		current_state = Status.vacant
		collision_shape_2d.disabled = false
		interaction_area.action_name="sleep"
		animated_sprite_2d.play("default")

		
		InteractionManager.reset_animation()
		
		return
