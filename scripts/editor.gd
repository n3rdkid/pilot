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
}

const horiz := 57 # No of columns
const size  := Vector2(32, 64) # Asset size

func _run() -> void:
	generate_for_dir("res://assets/characters/Bodies/")
	generate_for_dir("res://assets/characters/Eyes/")
	generate_for_dir("res://assets/characters/Hairstyles/")
	generate_for_dir("res://assets/characters/Outfits/")
	generate_for_dir("res://assets/characters/Accessories/")

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
