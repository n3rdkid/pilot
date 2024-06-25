@tool
extends EditorScript

# get the possible extensions of the ImageTexture resource (png, svg, etc)
var exts := ResourceSaver.get_recognized_extensions(ImageTexture.new())
const anims := {
   "static_right": [0],
   "static_up": [1],
   "static_left": [2],
   "static_down": [3],

   "idle_right": [57, 58, 59, 60, 61, 62],
   "idle_up": [63, 64, 65, 66, 67, 68],
   "idle_left": [69, 70, 71, 72, 73, 74],
   "idle_down": [75, 76, 77, 78, 79, 80],

   "walk_right": [114, 115, 116, 117, 118, 119],
   "walk_up": [120, 121, 122, 123, 124, 125],
   "walk_left": [126, 127, 128, 129, 130, 131],
   "walk_down": [132, 133, 134, 135, 136, 137],
	"sleep":[171,172,173,174,175,176]	,
	"sit_floor_right":[228,229,230,231,232,233]	,
	"sit_floor_left":[234,235,236,237,238,239]	,
	"sit_right":[285,286,287,288,289,290]	,
	"sit_left":[291,292,293,294,295,296]	,
	"take_phone_out":[342,343,344,345]	,
	"use_phone":[346,347,348,349]	,
	"put_phone_back":[350,351,352,353],	
	"read_book":[399,391,392,393,394,395]	,
	"turn_book_page":[396,397,398,399,400,401]	,
	"push_cart_right":[456,457,458,459,460,461]	,
	"push_cart_up":[462,463,464,465,466,467]	,
	"push_cart_left":[468,469,470,471,472,473]	,
	"push_cart_down":[474,475,476,477,478,479]	,
	"pickup_right":[513,514,515,516],	
	"carry_right":[517,518,519,520],	
	"putdown_right":[521,522,523,524],	
	"pickup_up":[525,526,527,528]	,
	"carry_up":[529,530,531,532],	
	"putdown_up":[533,534,535,536],	
	"pickup_left":[537,538,539,540]	,
	"carry_left":[541,542,543,544],	
	"putdown_left":[545,546,547,548],	
	"pickup_down":[549,550,551,552]	,
	"carry_down":[553,554,555,556],	
	"putdown_down":[557,558,559,560],	
	#"pickup_gift_right":[],	
	#"pickup_gift_up":[]	,
	#"pickup_gift_left":[]	,
	#"pickup_gift_down":[]	,
	#"lift_right":[],	
	#"lift_up":[]	,
	#"lift_left":[]	,
	#"lift_down":[]	,
	#"throw_right":[],	
	#"throw_up":[]	,
	#"throw_left":[]	,
	#"throw_down":[]	,
	#"hit_right":[],	
	#"hit_up":[]	,
	#"hit_left":[]	,
	#"hit_down":[]	,
	#
	#"punch_right":[],	
	#"punch_up":[]	,
	#"punch_left":[]	,
	#"punch_down":[]	,
	#
	#"stab_right":[],	
	#"stab_up":[]	,
	#"stab_left":[]	,
	#"stab_down":[]	,
	#
	#"grap_gun_up":[],	
	#"grap_gun_right":[]	,
	#"grap_gun_left":[]	,
	#"grap_gun_down":[]	,
	#
	#"gun_idle_up":[],	
	#"gun_idle_right":[]	,
	#"gun_idle_left":[]	,
	#"gun_idle_down":[]	,
	#
	#"shoot_up":[],	
	#"shoot_right":[]	,
	#"shoot_left":[]	,
	#"shoot_down":[]	,
	#
	#"hurt_up":[],	
	#"hurt_right":[]	,
	#"hurt_left":[]	,
	#"hurt_down":[]	,
}

const horiz := 57 # No of columns
const size  := Vector2(32, 64) # Asset size

func _run() -> void:
	generate_for_dir("res://assets/characters/Bodies/")
	generate_for_dir("res://assets/characters/Eyes/")
	generate_for_dir("res://assets/characters/Hairstyles/")
	generate_for_dir("res://assets/characters/Outfits/")
	generate_for_dir("res://assets/characters/Accessories/")
	generate_for_dir("res://assets/characters/Books/")
	generate_for_dir("res://assets/characters/Smartphones/")

func generate_for_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != '':
			if !dir.current_is_dir() && exts.has(file_name.get_extension()):
				var res := ResourceLoader.load(path.path_join(file_name))
				if res is Texture2D:
					generate_sprite_frames(res)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s" % path)
	
	
func generate_sprite_frames(texture: Texture2D) -> void:
	print("texture %s" % texture.resource_path)
	#var horiz := floori(texture.get_size().x / size.x)

	var resource_path := texture.resource_path

	var frames := SpriteFrames.new()
	frames.remove_animation("default")

	for anim_name in anims:
		frames.add_animation(anim_name)
		var frame_indexes: Array = anims[anim_name]

		for i in range(frame_indexes.size()):
			var index: int =  frame_indexes[i]
			var atlas      := AtlasTexture.new()
			atlas.atlas = texture
			var pos        := Vector2(size.x * (index % horiz), size.y * (index / horiz))
			atlas.region = Rect2(pos, size)
			frames.add_frame(anim_name, atlas, 1.0, i)

	var file_name := resource_path.get_file().trim_suffix("." + resource_path.get_extension())
	ResourceSaver.save(frames, resource_path.get_base_dir().path_join(file_name + ".tres"))
