class_name ShapeLook
extends Look

var shape: String
var size: float
var color: Color


func _init(look: Dictionary) -> void:
  shape = look.shape
  size = look.size
  color = Color(look.color)


func _draw() -> void:
  var half := size / 2.0
  match shape:
    "circle":
      draw_circle(Vector2.ZERO, half, color)
    "square":
      draw_rect(Rect2(-half, -half, size, size), color)
    "triangle":
      draw_colored_polygon(PackedVector2Array([
        Vector2(0, -half),
        Vector2(half, half),
        Vector2(-half, half),
      ]), color)


func bounding_radius() -> float:
  return size / sqrt(2.0)
