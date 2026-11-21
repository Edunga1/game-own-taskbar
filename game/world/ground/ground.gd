class_name Ground
extends Sprite2D

const META_FILE := "res://world/ground/builtin/mainland/ground.json"
const STYLE := "pixel"
const OUTLINE_PADDING := 1.0

var back_left := Vector2.ZERO
var back_right := Vector2.ZERO
var front_right := Vector2.ZERO
var front_left := Vector2.ZERO
var outline := PackedVector2Array()


func build(canvas_size: Vector2i) -> void:
  var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(META_FILE))
  var style: Dictionary = meta.styles[STYLE]
  texture = load(META_FILE.get_base_dir().path_join(style.image))
  var surface: Array[Vector2] = []
  for pair: Array in style.surface:
    surface.append(Vector2(pair[0], pair[1]))
  var drawn := Rect2(texture.get_image().get_used_rect())

  scale = Vector2.ONE * canvas_size.x / (surface[2].x - surface[3].x)
  position = Vector2(-surface[3].x, canvas_size.y / scale.y - drawn.end.y) * scale

  back_left = transform * surface[0]
  back_right = transform * surface[1]
  front_right = transform * surface[2]
  front_left = transform * surface[3]

  var area := drawn.grow(OUTLINE_PADDING)
  var outset := surface[3].x - area.position.x
  outline = transform * PackedVector2Array([
    Vector2(surface[0].x - outset, area.position.y),
    Vector2(surface[1].x + outset, area.position.y),
    Vector2(area.end.x, surface[2].y),
    Vector2(area.end.x, drawn.end.y),
    Vector2(area.position.x, drawn.end.y),
    Vector2(area.position.x, surface[3].y),
  ])


func random_point(margin: float) -> Vector2:
  var side := front_left - back_left
  var side_margin := margin * side.length() / side.y
  var y := randf_range(back_left.y + margin, front_left.y - margin)
  var depth := inverse_lerp(back_left.y, front_left.y, y)
  return Vector2(
    randf_range(lerpf(back_left.x, front_left.x, depth) + side_margin, lerpf(back_right.x, front_right.x, depth) - side_margin),
    y,
  )
