@tool
@icon("res://addons/func_godot/icons/icon_godot_ranger.svg")
## Local machine project wide settings. Can define global defaults for some FuncGodot properties.
## This resource works by saving and loading the properties from the project metadata rather than this resource directly.
class_name FuncGodotLocalConfig
extends Resource

enum PROPERTY {
	FGD_OUTPUT_FOLDER,
	TRENCHBROOM_GAME_CONFIG_FOLDER,
	NETRADIANT_CUSTOM_GAMEPACKS_FOLDER,
	MAP_EDITOR_GAME_PATH,
	GAME_PATH_MODELS_FOLDER,
	DEFAULT_INVERSE_SCALE
}

const CONFIG_PROPERTIES: Array[Dictionary] = [
	{
		"name": "fgd_output_folder",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
		"func_godot_type": PROPERTY.FGD_OUTPUT_FOLDER
	},
	{
		"name": "trenchbroom_game_config_folder",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
		"func_godot_type": PROPERTY.TRENCHBROOM_GAME_CONFIG_FOLDER
	},
	{
		"name": "netradiant_custom_gamepacks_folder",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
		"func_godot_type": PROPERTY.NETRADIANT_CUSTOM_GAMEPACKS_FOLDER
	},
	{
		"name": "map_editor_game_path",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
		"func_godot_type": PROPERTY.MAP_EDITOR_GAME_PATH
	},
	{
		"name": "game_path_models_folder",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_STRING,
		"func_godot_type": PROPERTY.GAME_PATH_MODELS_FOLDER
	},
	{
		"name": "default_inverse_scale_factor",
		"usage": PROPERTY_USAGE_EDITOR,
		"type": TYPE_FLOAT,
		"func_godot_type": PROPERTY.DEFAULT_INVERSE_SCALE
	}
]

const metadata_section = "addons/func_godot/local_config"

static func get_setting(name: PROPERTY) -> Variant:
	var config = CONFIG_PROPERTIES[name]
	var es = EditorInterface.get_editor_settings()
	return es.get_project_metadata(metadata_section, config['name'], _get_default_value(config['type']))
	
static func _get_default_value(type) -> Variant:
	match type:
		TYPE_STRING: return ''
		TYPE_INT: return 0
		TYPE_FLOAT: return 0.0
		TYPE_BOOL: return false
		TYPE_VECTOR2: return Vector2.ZERO
		TYPE_VECTOR3: return Vector3.ZERO
		TYPE_ARRAY: return []
		TYPE_DICTIONARY: return {}
	push_error("Invalid setting type. Returning null")
	return null

func _get_config_property(name: StringName) -> Variant:
	for config in CONFIG_PROPERTIES:
		if config['name'] == name: 
			return config
	return null

# Property overrides
func _get_property_list() -> Array:
	return CONFIG_PROPERTIES.duplicate()

func _get(property: StringName) -> Variant:
	var config = _get_config_property(property)
	if config == null and not config is Dictionary: 
		return null

	var es = EditorInterface.get_editor_settings()
	return es.get_project_metadata(metadata_section, config['name'], _get_default_value(config['type']))

func _set(property: StringName, value: Variant) -> bool:
	var config = _get_config_property(property)
	if config == null and not config is Dictionary: 
		return false

	var es = EditorInterface.get_editor_settings()
	es.set_project_metadata(metadata_section, config['name'], value)
	return true
