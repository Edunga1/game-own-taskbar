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
    var dict = JSON.parse_string(FileAccess.get_file_as_string(path.path_join(MANIFEST_FILE)))
    if dict is Dictionary:
      result.append(from_dict(dict, path))
    else:
      push_error("Invalid character manifest: %s" % path)
  return result


static func from_dict(dict: Dictionary, character_dir: String) -> CharacterData:
  var data := CharacterData.new()
  data.id = character_dir.get_file()
  data.dir = character_dir
  data.speed = dict.speed
  data.look = dict.look
  return data


func create_look() -> Look:
  if look.type == "sprite":
    return SpriteLook.new(look, dir)
  return ShapeLook.new(look)
