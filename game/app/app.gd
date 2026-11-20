extends Node2D

const BUILTIN_CHARACTERS_DIR := "res://characters/builtin"
const EXTENSION_CHARACTERS_DIR := "user://characters"

var world_shape := PackedVector2Array()

@onready var world: World = $World
@onready var menu: HBoxContainer = $UI/Menu
@onready var on_top_check: CheckBox = %OnTopCheck
@onready var close_button: Button = %CloseButton


func _ready() -> void:
  var canvas_size := _cover_usable_screen()
  world.shape_changed.connect(_on_world_shape_changed)
  menu.item_rect_changed.connect(_update_mouse_passthrough)
  world.setup(canvas_size, _load_characters())
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


func _load_characters() -> Array[CharacterData]:
  DirAccess.make_dir_recursive_absolute(EXTENSION_CHARACTERS_DIR)
  var extensions := CharacterData.load_dir(EXTENSION_CHARACTERS_DIR)
  if extensions.is_empty():
    return CharacterData.load_dir(BUILTIN_CHARACTERS_DIR)
  return extensions


func _on_on_top_toggled(enabled: bool) -> void:
  get_window().always_on_top = enabled


func _cover_usable_screen() -> Vector2i:
  var usable := DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
  # Matching the work area exactly makes Godot flip the window height on every passthrough update.
  var canvas := usable.grow_side(SIDE_TOP, -1)
  var window := get_window()
  window.position = canvas.position
  window.size = canvas.size
  return canvas.size


func _on_world_shape_changed(shape: PackedVector2Array) -> void:
  world_shape = shape
  _update_mouse_passthrough()


func _update_mouse_passthrough() -> void:
  var menu_rect := menu.get_global_rect()
  var menu_shape := PackedVector2Array([
    menu_rect.position,
    Vector2(menu_rect.end.x, menu_rect.position.y),
    menu_rect.end,
    Vector2(menu_rect.position.x, menu_rect.end.y),
  ])
  var merged := Geometry2D.merge_polygons(world_shape, menu_shape)
  if merged.is_empty():
    return
  get_window().mouse_passthrough_polygon = merged[0]
