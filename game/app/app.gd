extends Node2D

const BUILTIN_CHARACTERS_DIR := "res://characters/builtin"
const EXTENSION_CHARACTERS_DIR := "user://characters"

var world_shape := PackedVector2Array()
var drag_offset := Vector2i.ZERO

@onready var world: World = $World
@onready var menu: HBoxContainer = $UI/Menu
@onready var load_button: Button = %LoadButton
@onready var character_dialog: FileDialog = %CharacterDialog
@onready var move_handle: Button = %MoveHandle
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
  move_handle.gui_input.connect(_on_move_handle_gui_input)
  load_button.pressed.connect(character_dialog.popup)
  character_dialog.dir_selected.connect(_on_character_dir_selected)


func _load_characters() -> Array[CharacterData]:
  DirAccess.make_dir_recursive_absolute(EXTENSION_CHARACTERS_DIR)
  var extensions := CharacterData.load_dir(EXTENSION_CHARACTERS_DIR)
  if extensions.is_empty():
    return CharacterData.load_dir(BUILTIN_CHARACTERS_DIR)
  return extensions


func _on_character_dir_selected(source_dir: String) -> void:
  if CharacterData.install(source_dir, EXTENSION_CHARACTERS_DIR) > 0:
    world.show_characters(_load_characters())
  else:
    OS.alert("No character folder found in the selected folder.", "Load Character")


func _on_on_top_toggled(enabled: bool) -> void:
  get_window().always_on_top = enabled


func _on_move_handle_gui_input(event: InputEvent) -> void:
  var button := event as InputEventMouseButton
  var motion := event as InputEventMouseMotion
  if button and button.button_index == MOUSE_BUTTON_LEFT and button.pressed:
    drag_offset = DisplayServer.mouse_get_position() - get_window().position
  elif motion and motion.button_mask & MOUSE_BUTTON_MASK_LEFT:
    get_window().position = DisplayServer.mouse_get_position() - drag_offset


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
