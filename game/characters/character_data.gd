class_name CharacterData
extends RefCounted

var id: String
var shape: String
var size: float
var color: Color
var speed: float


static func load_dir(dir: String) -> Array[CharacterData]:
  var result: Array[CharacterData] = []
  for file in DirAccess.get_files_at(dir):
    if file.get_extension() == "json":
      var text := FileAccess.get_file_as_string(dir.path_join(file))
      result.append(from_dict(JSON.parse_string(text)))
  return result


static func from_dict(dict: Dictionary) -> CharacterData:
  var data := CharacterData.new()
  data.id = dict.id
  data.shape = dict.shape
  data.size = dict.size
  data.color = Color(dict.color)
  data.speed = dict.speed
  return data
