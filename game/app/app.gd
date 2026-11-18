extends Node2D

@export_range(0.05, 1.0) var app_height := 0.25

@onready var world: World = $World
@onready var on_top_check: CheckBox = %OnTopCheck
@onready var close_button: Button = %CloseButton


func _ready() -> void:
  var size := _fit_window_to_bottom()
  world.shape_changed.connect(_on_world_shape_changed)
  world.setup(size)
  _setup_menu()


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    get_tree().quit()


func _setup_menu() -> void:
  on_top_check.button_pressed = DisplayServer.window_get_flag(
    DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
    get_window().get_window_id(),
  )
  on_top_check.toggled.connect(_on_on_top_toggled)
  close_button.pressed.connect(get_tree().quit)


func _on_on_top_toggled(enabled: bool) -> void:
  get_window().always_on_top = enabled


func _fit_window_to_bottom() -> Vector2i:
  var screen := DisplayServer.get_primary_screen()
  var usable := DisplayServer.screen_get_usable_rect(screen)
  var height := int(DisplayServer.screen_get_size(screen).y * app_height)
  var size := Vector2i(usable.size.x, height)

  var window := get_window()
  window.size = size
  window.position = Vector2i(usable.position.x, usable.end.y - height)
  return size


func _on_world_shape_changed(shape: PackedVector2Array) -> void:
  get_window().mouse_passthrough_polygon = shape
