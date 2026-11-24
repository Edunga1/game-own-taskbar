class_name World
extends Node2D

signal shape_changed(shape: PackedVector2Array)

@onready var ground: Ground = $Ground
@onready var characters: Node2D = $Characters


func setup(canvas_size: Vector2i, character_data: Array[CharacterData]) -> void:
  ground.build(canvas_size)
  show_characters(character_data)
  shape_changed.emit(ground.outline)


func show_characters(character_data: Array[CharacterData]) -> void:
  for character in characters.get_children():
    character.free()
  for data: CharacterData in character_data:
    characters.add_child(Character.new(data, ground))
