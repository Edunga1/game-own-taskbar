class_name Ground
extends Polygon2D

const HEIGHT_RATIO := 0.15
const TOP_WIDTH_RATIO := 0.9

var top := 0.0
var bottom := 0.0
var width := 0.0
var top_inset := 0.0


func build(canvas_size: Vector2i) -> void:
  width = canvas_size.x
  bottom = canvas_size.y
  top = bottom * (1.0 - HEIGHT_RATIO)
  top_inset = width * (1.0 - TOP_WIDTH_RATIO) / 2.0
  polygon = PackedVector2Array([
    Vector2(top_inset, top),
    Vector2(width - top_inset, top),
    Vector2(width, bottom),
    Vector2(0, bottom),
  ])


func random_point(margin: float) -> Vector2:
  var height := bottom - top
  var y := randf_range(top + margin, bottom - margin)
  var inset := lerpf(top_inset, 0.0, inverse_lerp(top, bottom, y))
  var side_margin := margin * Vector2(top_inset, height).length() / height
  return Vector2(randf_range(inset + side_margin, width - inset - side_margin), y)
