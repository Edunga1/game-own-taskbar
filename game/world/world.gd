class_name World
extends Node2D

signal shape_changed(shape: PackedVector2Array)

const BUILTIN_CHARACTERS_DIR := "res://characters/builtin"

@onready var ground: Ground = $Ground
@onready var characters: Node2D = $Characters


func setup(canvas_size: Vector2i) -> void:
  ground.build(canvas_size)
  for data: CharacterData in CharacterData.load_dir(BUILTIN_CHARACTERS_DIR):
    characters.add_child(Character.new(data, ground))
  shape_changed.emit(ground.polygon)
