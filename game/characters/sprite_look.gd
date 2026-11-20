class_name SpriteLook
extends Look

const MOVE_ANIMATION := "walk"

var sprite := AnimatedSprite2D.new()
var frame_size := Vector2.ZERO
var directions := {}


func _init(look: Dictionary, dir: String) -> void:
  scale = Vector2.ONE * look.get("scale", 1.0)
  sprite.sprite_frames = SpriteFrames.new()
  for sheet: String in look.sheets:
    _add_sheet(dir.path_join(sheet))
  add_child(sprite)


func bounding_radius() -> float:
  return frame_size.x / 2.0 * scale.x


func face(direction: Vector2) -> void:
  if direction.is_zero_approx():
    return
  var nearest := ""
  for candidate: String in directions:
    if nearest.is_empty() or direction.dot(directions[candidate]) > direction.dot(directions[nearest]):
      nearest = candidate
  sprite.play(_animation_name(MOVE_ANIMATION, nearest))


func _add_sheet(path: String) -> void:
  var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
  var image := Image.load_from_file(path.get_base_dir().path_join(meta.image))
  var texture := ImageTexture.create_from_image(image)
  frame_size = Vector2(meta.frame_width, meta.frame_height)
  if meta.style == "pixel":
    texture_filter = TEXTURE_FILTER_NEAREST
  for row in int(meta.rows):
    var direction: String = meta.row_order[row]
    var vector: Array = meta.screen_vector[direction]
    directions[direction] = Vector2(vector[0], vector[1]).normalized()
    var animation := _animation_name(meta.animation, direction)
    sprite.sprite_frames.add_animation(animation)
    sprite.sprite_frames.set_animation_speed(animation, meta.fps)
    for column in int(meta.columns):
      var frame := AtlasTexture.new()
      frame.atlas = texture
      frame.region = Rect2(Vector2(column, row) * frame_size, frame_size)
      sprite.sprite_frames.add_frame(animation, frame)


func _animation_name(animation: String, direction: String) -> String:
  return "%s_%s" % [animation, direction]
