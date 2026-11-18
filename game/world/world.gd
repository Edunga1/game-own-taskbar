class_name World
extends Node2D

signal shape_changed(shape: PackedVector2Array)

@onready var ground: Ground = $Ground


func setup(canvas_size: Vector2i) -> void:
  ground.build(canvas_size)
  shape_changed.emit(ground.polygon)
