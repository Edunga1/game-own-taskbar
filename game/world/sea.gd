class_name Sea
extends Polygon2D


func build(size: Vector2i) -> void:
  var amplitude := size.y * 0.1
  var points := PackedVector2Array()
  var x := 0.0
  while x < size.x:
    points.append(Vector2(x, _wave_y(x, amplitude)))
    x += 4.0
  points.append(Vector2(size.x, _wave_y(size.x, amplitude)))
  points.append(Vector2(size.x, size.y))
  points.append(Vector2(0, size.y))
  polygon = points


func _wave_y(x: float, amplitude: float) -> float:
  var t := x / 240.0 * TAU
  return amplitude * (1.0 + 0.7 * sin(t) + 0.3 * sin(t * 2.3 + 1.0))
