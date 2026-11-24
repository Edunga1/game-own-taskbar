class_name CharacterData
extends RefCounted

const MANIFEST_FILE := "character.json"

var id: String
var dir: String
var speed: float
var look: Dictionary


static func load_dir(dir: String) -> Array[CharacterData]:
  var result: Array[CharacterData] = []
  for child in DirAccess.get_directories_at(dir):
    var path := dir.path_join(child)
    var dict = _read_manifest(path)
    if dict is Dictionary:
      result.append(from_dict(dict, path))
    else:
      push_error("Invalid character manifest: %s" % path)
  return result


static func install(source_dir: String, library_dir: String) -> int:
  var source := source_dir.simplify_path()
  var installed := _install_character(source, library_dir)
  for child in DirAccess.get_directories_at(source):
    installed += _install_character(source.path_join(child), library_dir)
  return installed


static func from_dict(dict: Dictionary, character_dir: String) -> CharacterData:
  var data := CharacterData.new()
  data.id = character_dir.get_file()
  data.dir = character_dir
  data.speed = dict.speed
  data.look = dict.look
  return data


static func _read_manifest(character_dir: String) -> Variant:
  return JSON.parse_string(FileAccess.get_file_as_string(character_dir.path_join(MANIFEST_FILE)))


static func _install_character(character_dir: String, library_dir: String) -> int:
  var target := ProjectSettings.globalize_path(library_dir).path_join(character_dir.get_file())
  if not FileAccess.file_exists(character_dir.path_join(MANIFEST_FILE)):
    return 0
  if character_dir == target:
    return 1
  var look: Dictionary = _read_manifest(character_dir).look
  var files := PackedStringArray([MANIFEST_FILE])
  if look.type == "sprite":
    files.append_array(SpriteLook.used_files(look, character_dir))
  for file in files:
    DirAccess.make_dir_recursive_absolute(target.path_join(file).get_base_dir())
    DirAccess.copy_absolute(character_dir.path_join(file), target.path_join(file))
  return 1


func create_look() -> Look:
  if look.type == "sprite":
    return SpriteLook.new(look, dir)
  return ShapeLook.new(look)
