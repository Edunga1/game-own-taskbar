class_name Ground
extends Polygon2D

const HEIGHT_RATIO := 0.15
const TOP_WIDTH_RATIO := 0.9


func build(canvas_size: Vector2i) -> void:
  var top := canvas_size.y * (1.0 - HEIGHT_RATIO)
  var top_inset := canvas_size.x * (1.0 - TOP_WIDTH_RATIO) / 2.0
  polygon = PackedVector2Array([
    Vector2(top_inset, top),
    Vector2(canvas_size.x - top_inset, top),
    Vector2(canvas_size.x, canvas_size.y),
    Vector2(0, canvas_size.y),
  ])
