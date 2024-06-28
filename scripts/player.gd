extends CharacterBody2D
@onready var body = $Body
@onready var eyes = $Eyes
@onready var outfits = $Outfits
@onready var accessories = $Accessories

const SPEED = 100.0
var current_direction = "down"

func _physics_process(delta):
	move_player(delta)
	move_and_slide()
	
func move_player(delta):
	if(InteractionManager.is_animating):
		return
	var is_moving:bool  = true
	if(Input.is_action_pressed("ui_right")):
		velocity.x = SPEED
		velocity.y = 0
		current_direction="right"
	elif(Input.is_action_pressed("ui_left")):
		velocity.x = -SPEED
		velocity.y = 0
		current_direction="left"
	elif(Input.is_action_pressed("ui_down")):
		velocity.x = 0
		velocity.y = SPEED
		current_direction="down"
	elif(Input.is_action_pressed("ui_up")):
		velocity.x = 0
		velocity.y = -SPEED
		current_direction="up"
	else:
		velocity.x = 0
		velocity.y = 0
		is_moving=false
	play_animation(is_moving)
	move_and_slide()

func play_animation(is_moving:bool):
	var animation_name = getAnimationName(is_moving)
	body.play(animation_name)
	eyes.play(animation_name)
	outfits.play(animation_name)
	accessories.play(animation_name)
	pass

func getAnimationName(is_moving:bool):
	if(is_moving):
		return "walk_"+current_direction
	return "idle_"+current_direction
