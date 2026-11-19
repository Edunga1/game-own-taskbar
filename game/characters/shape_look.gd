class_name ShapeLook
extends Node2D

var data: CharacterData


func _init(character_data: CharacterData) -> void:
  data = character_data


func _draw() -> void:
  var half := data.size / 2.0
  match data.shape:
    "circle":
      draw_circle(Vector2.ZERO, half, data.color)
    "square":
      draw_rect(Rect2(-half, -half, data.size, data.size), data.color)
    "triangle":
      draw_colored_polygon(PackedVector2Array([
        Vector2(0, -half),
        Vector2(half, half),
        Vector2(-half, half),
      ]), data.color)


func bounding_radius() -> float:
  return data.size / sqrt(2.0)
