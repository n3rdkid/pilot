extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var body_sprite = player.get_node("Body")
@onready var eyes_sprite = player.get_node("Eyes")
@onready var outfits_sprite = player.get_node("Outfits")
@onready var accessories_sprite = player.get_node("Accessories")

@onready var label = $Label

const base_text = "[E] to "

var active_areas = []
var can_interact = true
var is_animating = false

func register_area(area: ):
	active_areas.push_front(area)
	
func unregister_area(area:InteractionArea):
	var idx= active_areas.find(area)
	if(idx == -1):
		return
	active_areas.remove_at(idx)
	
func _process(delta):
	if(active_areas.size() > 0 && can_interact):
		active_areas.sort_custom(_sort_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 72
		label.global_position.x -= label.size.x/2
		print("Show label")
		
		label.show()
	else:
		print("Hide label")
		label.hide()
func _sort_distance_to_player(area1,area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if(event.is_action_pressed("Interact") && can_interact):
		if(active_areas.size() > 0):
			can_interact = false
			label.hide()
			await active_areas[0].interact.call()
			can_interact = true

func animate_player_interaction(animation_name):
	is_animating = true
	if(active_areas[0].can_animate_player):
		var animation_position : Vector2 =  active_areas[0].get_node("AnimationPosition").global_position
		player.global_position = animation_position
		print("Animation Position : ", animation_position)
		
	body_sprite.play(animation_name)
	eyes_sprite.play(animation_name)
	outfits_sprite.play(animation_name)
	accessories_sprite.play(animation_name)
	print("Animate Player : ",animation_name)

func reset_animation():
	if(active_areas[0].can_animate_player):
		var reset_position : Vector2 = active_areas[0].get_node("ResetPosition").global_position
		print("Reset Position : ", reset_position)
		player.global_position = reset_position
		print("Reset Position : ", reset_position)
		
	is_animating = false
	
