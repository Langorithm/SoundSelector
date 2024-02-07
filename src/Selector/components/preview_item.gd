extends HBoxContainer
class_name PreviewItem

signal favorite_checked
signal favorite_unchecked

@export var file_path: StringName
@onready var texture_button: TextureButton = $TextureButton

var _sound_preview

const SOUND_BUTTON = preload("res://components/SoundButton.tscn")

func _ready() -> void:
	assert(file_path, "File path not set for PreviewItem")
	
	#Set up Sound/SoundPreview
	if not _sound_preview:
		_sound_preview = SOUND_BUTTON.instantiate() as SoundPreview
		add_child(_sound_preview)
		_sound_preview.load_file(file_path)
	
	
	#Set up signal relay
	texture_button.button_up.connect(
		func(): 
			if texture_button.button_pressed:
				emit_signal("favorite_checked")
			else:
				emit_signal("favorite_unchecked")
	)
	
	#Organize Layout
	texture_button.move_to_front()
	_sound_preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
