class_name Character
extends Node2D

var data: CharacterData
var ground: Ground
var look: Look
var target := Vector2.ZERO


func _init(character_data: CharacterData, walk_ground: Ground) -> void:
  data = character_data
  ground = walk_ground
  name = data.id
  look = data.create_look()
  add_child(look)


func _ready() -> void:
  position = _next_target()
  target = _next_target()


func _process(delta: float) -> void:
  position = position.move_toward(target, data.speed * delta)
  if position == target:
    target = _next_target()
  look.face(target - position)


func _next_target() -> Vector2:
  return ground.random_point(look.bounding_radius())
