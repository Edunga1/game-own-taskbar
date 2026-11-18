class_name World
extends Node2D

signal shape_changed(shape: PackedVector2Array)

@onready var sea: Sea = $Sea


func setup(size: Vector2i) -> void:
  sea.build(size)
  shape_changed.emit(sea.polygon)
